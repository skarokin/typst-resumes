FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# chrome/chromedriver + minimal deps for headless in cloud run
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium chromium-driver \
    ca-certificates \
    fonts-liberation fonts-noto-color-emoji \
    libasound2 libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 \
    libdrm2 libgbm1 libgtk-3-0 libnspr4 libnss3 libx11-6 \
    libxcomposite1 libxdamage1 libxext6 libxfixes3 libxrandr2 libxshmfence1 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt /app/
RUN pip install -r requirements.txt --no-cache-dir

COPY . /app

# helpful envs (code should add --headless=new --no-sandbox --disable-dev-shm-usage)
ENV CHROME_BIN=/usr/bin/chromium \
    CHROMEDRIVER=/usr/bin/chromedriver \
    PYTHONIOENCODING=utf-8

CMD ["gunicorn", "--bind", ":8080", "--workers", "1", "--threads", "8", "--timeout", "0", "main:app"]