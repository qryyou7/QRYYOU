#!/bin/bash
set -e

echo "🚀 Starting X-UI + nginx reverse proxy..."

# تنظیم پورت روی 8080 جهت تایید Health Check
export NGINX_PORT=8080

cd /usr/local/x-ui

echo "🔧 Applying panel settings via x-ui CLI..."
# حذف webBasePath تا مسیر اصلی / به درستی پاسخ دهد
./x-ui setting -port 2053 || true

echo "🔧 Building nginx.conf for fixed port: $NGINX_PORT"
envsubst '${NGINX_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "▶️  Starting x-ui in background..."
./x-ui &
X_UI_PID=$!

# زمان بیشتر برای بالا آمدن کامل دیتابیس و سرویس X-UI
sleep 6

echo "▶️  Starting nginx in foreground on port $NGINX_PORT..."
nginx -t
exec nginx -g "daemon off;"
