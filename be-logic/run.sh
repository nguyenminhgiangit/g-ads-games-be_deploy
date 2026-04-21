#!/bin/bash
set -e

# 1. Tải biến môi trường từ file .env.process
ENV_FILE=".env.process"

if [ -f "$ENV_FILE" ]; then
    echo "Loading environment variables from $ENV_FILE"
    # Đọc file, loại bỏ comment và export vào shell
    export $(grep -v '^#' $ENV_FILE | xargs)
else
    echo "❌ Error: $ENV_FILE not found!"
    exit 1
fi

# 2. Sử dụng biến APP_NAME từ file .env.process
# Nếu trong file không có APP_NAME, sẽ dùng giá trị mặc định là 'default-app'
APP_NAME=${APP_NAME:-"default-app"}
ENTRY_POINT="lib/app.js"

echo "📦 Installing production dependencies..."
npm ci --omit=dev

echo "📦 Checking PM2 status for: $APP_NAME"

# 3. Kiểm tra xem app đã tồn tại trong danh sách PM2 chưa
if pm2 describe $APP_NAME > /dev/null 2>&1; then
    echo "🔄 $APP_NAME already exists, restarting..."
    pm2 restart $APP_NAME
else
    echo "🚀 $APP_NAME is starting new instance..."
    pm2 start $ENTRY_POINT --name $APP_NAME
fi

pm2 save

echo "✅ $APP_NAME is ready"