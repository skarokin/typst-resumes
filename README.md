# typst-resumes
scheduled scan so i can auto-version control my resume without typst pro

## prereqs
- gcp project w/ billing enabled
- typst account
- github repo & fine-grained personal access token with "Content: Read & Write" access to that repo
- have gcloud cli & docker installed

## setup
- add two secret to GCP secrets manager:
    - `typst-credentials:TYPST_USERNAME={YOUR_USERNAME},TYPST_PASSWORD={YOUR_PASSWORD}`
    - `github-token:{YOUR_PERSONAL_ACCESS_TOKEN}`

```sh
export PROJECT_ID=your-gcp-project-id
export REPO=your_git_username/your_repo

# build docker image (mac command)
docker buildx build --platform linux/amd64 -t gcr.io/${PROJECT_ID}/typst-resumes .

# push image
docker push gcr.io/${PROJECT_ID}/typst-resumes

# deploy to cloud run
gcloud run deploy typst-resumes \
  --image gcr.io/${PROJECT_ID}/typst-resumes \
  --platform managed \
  --region us-central1 \
  --project ${PROJECT_ID} \
  --memory 2Gi \
  --cpu 1 \
  --timeout 900 \
  --port 8080 \
  --set-env-vars="GCP_PROJECT_ID=${PROJECT_ID},GITHUB_REPOSITORY=${REPO},GITHUB_BRANCH=main" \
  --no-allow-unauthenticated

# setup access to secrets maanger
SERVICE_ACCOUNT=$(gcloud run services describe typst-resumes \
  --region=us-central1 \
  --project=${PROJECT_ID} \
  --format="value(spec.template.spec.serviceAccountName)")

gcloud secrets add-iam-policy-binding github-token \
  --member="serviceAccount:${SERVICE_ACCOUNT}" \
  --role="roles/secretmanager.secretAccessor" \
  --project=${PROJECT_ID}

gcloud secrets add-iam-policy-binding typst-credentials \
  --member="serviceAccount:${SERVICE_ACCOUNT}" \
  --role="roles/secretmanager.secretAccessor" \
  --project=${PROJECT_ID}

# setup daily scheduler
SERVICE_URL=$(gcloud run services describe typst-resumes \
  --region=us-central1 \
  --project=${PROJECT_ID} \
  --format="value(status.url)")

gcloud scheduler jobs create http typst-resume-sync \
  --schedule="0 9 * * *" \
  --uri="${SERVICE_URL}" \
  --http-method=POST \
  --project=${PROJECT_ID} \
  --location=us-central1 \
  --time-zone="America/New_York" \
  --oidc-service-account-email="${SERVICE_ACCOUNT}"

# manual test
curl -X POST "${SERVICE_URL}/" \
  -H "Authorization: Bearer $(gcloud auth print-identity-token)"
```