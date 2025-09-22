from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from contextlib import contextmanager
import os
import re
import base64
import requests
from urllib.parse import quote
from google.cloud import secretmanager
from flask import Flask, jsonify

app = Flask(__name__)

GCP_PROJECT_ID = os.getenv("GCP_PROJECT_ID", "")

def _repo_env():
    repo = os.getenv("GITHUB_REPOSITORY", "")
    token = os.getenv("GITHUB_TOKEN", "")
    branch = os.getenv("GITHUB_BRANCH", "main")
    base_dir = os.getenv("BASE_DIR", "").strip().strip("/")

    if not token:
        # try to get from google cloud secret manager
        secretmanager_client = secretmanager.SecretManagerServiceClient()
        project_id = GCP_PROJECT_ID
        secret_name = "github-token"
        secret_version = "latest"
        name = f"projects/{project_id}/secrets/{secret_name}/versions/{secret_version}"
        response = secretmanager_client.access_secret_version(request={"name": name})
        token = response.payload.data.decode("UTF-8")

    if not repo or not token:
        raise ValueError("Missing GITHUB_REPOSITORY or GITHUB_TOKEN")

    return {
        "repo": repo,
        "token": token,
        "branch": branch,
        "base_dir": base_dir
    }

def _github_get_file_raw(repo, path, token, branch):
    url = f"https://api.github.com/repos/{repo}/contents/{quote(path)}?ref={quote(branch)}"
    r = requests.get(url, headers={
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github.raw"
    })
    if r.status_code == 200:
        return r.content  # bytes
    if r.status_code == 404:
        return None
    raise RuntimeError(f"GitHub GET raw failed ({r.status_code}): {r.text}")

def _github_get_file_sha(repo, path, token, branch):
    url = f"https://api.github.com/repos/{repo}/contents/{quote(path)}?ref={quote(branch)}"
    req = requests.get(url, headers={"Authorization": f"Bearer {token}", "Accept": "application/vnd.github+json"})
    if req.status_code == 200:
        return req.json().get("sha")
    if req.status_code == 404:
        return None
    raise RuntimeError(f"GitHub GET failed ({req.status_code}): {req.text}")

def _github_upsert_file(repo, path, content, message, token, branch):
    # if file exists and content is identical, skip commit
    existing_sha = _github_get_file_sha(repo, path, token, branch)
    if existing_sha is not None:
        existing_bytes = _github_get_file_raw(repo, path, token, branch)
        if existing_bytes is not None:
            new_bytes = (content or "").encode("utf-8")
            if existing_bytes == new_bytes:
                return {"status": "skipped", "reason": "no-change"}

    # upsert
    url = f"https://api.github.com/repos/{repo}/contents/{quote(path)}"
    body = {
        "message": message,
        "content": base64.b64encode((content or "").encode("utf-8")).decode("ascii"),
        "branch": branch,
    }
    if existing_sha:
        body["sha"] = existing_sha

    r = requests.put(url, headers={"Authorization": f"Bearer {token}", "Accept": "application/vnd.github+json"}, json=body)
    if r.status_code not in (200, 201):
        raise RuntimeError(f"GitHub PUT failed ({r.status_code}): {r.text}")
    return {"status": "upserted", "commit": r.json().get("commit", {}).get("sha")}

def _safe_dir_name(name):
    # simple sanitization for directory names
    return re.sub(r"[^\w\-. ]+", "_", name).strip().replace(" ", "_")

def clean_content(content):
    if not content:
        return ""
    
    # remove zero-width spaces and other problematic characters
    content = re.sub(r'[\u200B-\u200D\uFEFF]', '', content)
    content = re.sub(r'[\u2060]', '', content)
    content = re.sub(r'[\u00A0]', ' ', content)

    # remove other control characters except newlines and tabs
    content = re.sub(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]', '', content)
    
    return content.strip()

def _read_editor_full_text(driver):
    js = """
        const root = document.querySelector('.cm-editor');
        if (!root) return null;

        // in CM6, any DOM node in the editor tree gets a `cmView` object.
        // that object has a `.view` pointing to the EditorView instance.
        const cv = root.cmView || (root.querySelector('.cm-content') && root.querySelector('.cm-content').cmView);
        const view = cv && cv.view;
        if (view && view.state && view.state.doc) {
            // entire buffer as a string
            return view.state.doc.toString();
        }
        return null;
    """
    return driver.execute_script(js) or ""

def get_project_files(driver, project_url):
    driver.get(project_url)

    WebDriverWait(driver, 15).until(
        EC.presence_of_element_located((By.CSS_SELECTOR, ".cm-editor .cm-content"))
    )

    # open file list sidebar
    try:
        WebDriverWait(driver, 5).until(
            EC.presence_of_element_located((By.XPATH, "//ul[contains(@class,'_fileList_')]"))
        )
    except TimeoutException:
        try:
            toggle = WebDriverWait(driver, 8).until(
                EC.element_to_be_clickable((By.XPATH, "//button[contains(@aria-label,'Explore files') or contains(@title,'Explore files')]"))
            )
            try:
                toggle.click()
            except Exception:
                driver.execute_script("arguments[0].click();", toggle)
            WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.XPATH, "//ul[contains(@class,'_fileList_')]"))
            )
        except TimeoutException:
            print("File list sidebar not found; 'Explore files' toggle not available.")
            return {}

    # file list present
    try:
        WebDriverWait(driver, 12).until(
            EC.presence_of_element_located((By.XPATH, "//ul[contains(@class,'_fileList_')]"))
        )
    except TimeoutException:
        print("File list sidebar not found (//ul[contains(@class,'_fileList_')]). Is the sidebar hidden?")
        return {}

    # collect names via li->button->div->span
    names = []
    for sp in driver.find_elements(By.XPATH, "//ul[contains(@class,'_fileList_')]/li//button/div/span"):
        nm = (sp.get_attribute("textContent") or "").strip()
        if nm and nm.lower().endswith(".typ"):
            names.append(nm)

    results = {}
    for fname in names:
        # read prev buffer before switching
        prev = _read_editor_full_text(driver)

        # find the li for this filename and click its parent button
        target_btn = None
        for li in driver.find_elements(By.XPATH, "//ul[contains(@class,'_fileList_')]/li"):
            try:
                span = li.find_element(By.XPATH, ".//button/div/span")
                text = (span.get_attribute("textContent") or "").strip()
                if text == fname:
                    target_btn = li.find_element(By.XPATH, ".//button")
                    break
            except Exception:
                continue

        if not target_btn:
            print(f"Skipping {fname}: parent button not found")
            continue

        try:
            driver.execute_script("arguments[0].scrollIntoView({block:'center'});", target_btn)
            driver.execute_script("arguments[0].click();", target_btn)  # avoid interception
        except Exception:
            try:
                target_btn.click()
            except Exception as e:
                print(f"Click failed for {fname}: {e}")
                continue

        # wait for content to change; if same file, just proceed
        try:
            WebDriverWait(driver, 6).until(lambda d: _read_editor_full_text(d) != prev)
        except Exception:
            pass

        content = _read_editor_full_text(driver)
        results[fname] = clean_content(content)

    return results

def auth_to_typst(driver, username, password):
    driver.get("https://typst.app/signin")

    email_field = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.ID, "email"))
    )
    email_field.send_keys(username)

    password_field = driver.find_element(By.ID, "password")
    password_field.send_keys(password)

    submit_button = driver.find_element(By.CSS_SELECTOR, "input[type='submit'][value='Sign in']")
    submit_button.click()

    WebDriverWait(driver, 10).until(
        EC.url_changes("https://typst.app/signin")
    )

    print(f"Successfully logged in! Current URL: {driver.current_url}")

def get_projects(driver):
    projects = []

    WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.CSS_SELECTOR, "[class*='_projects_']"))
    )

    project_elements = driver.find_elements(By.CSS_SELECTOR, "[class*='_project_']")

    for project in project_elements:
        try:
            # get all direct child divs of project element
            child_divs = project.find_elements(By.XPATH, "./div")
            if len(child_divs) != 2:
                print("Unexpected project element structure, skipping...")
                continue
            
            # first div contains the link
            first_div = child_divs[0]
            link_element = first_div.find_element(By.TAG_NAME, "a")
            project_url = link_element.get_attribute("href")

            # second div contains the name
            second_div = child_divs[1]
            project_name = second_div.text

            projects.append({
                "name": project_name,
                "url": project_url
            })
        except Exception as e:
            print(f"Error retrieving project details: {e}")
            continue
    
    return projects

def get_credentials():
    username = os.getenv("TYPST_USERNAME")
    password = os.getenv("TYPST_PASSWORD")
    if not username or not password:
        # this is in prod, get from google cloud secret manager
        secretmanager_client = secretmanager.SecretManagerServiceClient()
        project_id = GCP_PROJECT_ID
        secret_name = "typst-credentials"
        secret_version = "latest"
        name = f"projects/{project_id}/secrets/{secret_name}/versions/{secret_version}"
        response = secretmanager_client.access_secret_version(request={"name": name})
        secret_payload = response.payload.data.decode("UTF-8")
        credentials = dict(item.split("=") for item in secret_payload.split(","))
        username = credentials.get("TYPST_USERNAME")
        password = credentials.get("TYPST_PASSWORD")
    
    return username, password

@contextmanager
def setup():
    chrome_options = Options()
    chrome_options.add_argument("--headless=new")
    chrome_options.add_argument("--no-sandbox")              # needed in Cloud Run
    chrome_options.add_argument("--disable-dev-shm-usage")   # reduce /dev/shm pressure
    chrome_options.add_argument("--window-size=1600,1000")
    driver = webdriver.Chrome(options=chrome_options)
    try:
        yield driver
    finally:
        driver.quit()   # aka defer in go

def main():
    username, password = get_credentials()
    if not username or not password:
        raise ValueError("Missing TYPST_USERNAME or TYPST_PASSWORD")
    
    cfg = _repo_env()
    repo = cfg["repo"]
    token = cfg["token"]
    branch = cfg["branch"]
    base_dir = cfg["base_dir"]
    
    with setup() as driver:
        auth_to_typst(driver, username, password)
        projects = get_projects(driver)

        for idx, project in enumerate(projects, start=1):
            print(f"{idx}. {project['name']}")
            files = get_project_files(driver, project['url'])
            if not files:
                print("  No files found.")
                continue

            proj_dir = _safe_dir_name(project["name"])
            for filename, content in files.items():
                rel_path = f"{proj_dir}/{filename}"
                if base_dir:
                    rel_path = f"{base_dir}/{rel_path}"
                msg = f"chore(typst): update {rel_path}"
                try:
                    _github_upsert_file(repo, rel_path, content, msg, token, branch)
                    print(f"  - Upserted {rel_path} ({len(content)} chars)")
                except Exception as e:
                    print(f"  - Failed to upsert {rel_path}: {e}")

@app.route("/", methods=["GET", "POST"])
def run_typst_sync():
    try:
        main()
        return jsonify({"status": "success"}), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500
    
@app.route("/health", methods=["GET"])
def health_check():
    return jsonify({"status": "healthy"}), 200

if __name__ == "__main__":
    port = int(os.environ.get('PORT', 8080))
    app.run(host="0.0.0.0", port=port)