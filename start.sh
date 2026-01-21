cat << 'EOF' > start.sh
#!/bin/bash

# --- CẤU HÌNH ---
WEBHOOK_URL="https://discord.com/api/webhooks/1460633815578968239/E5Ck-CCpCwQNUtGXA9z-VpWwcQzZz7M7meSapdb8i7f0cZ_XdnOg4EHeCQ6x4rfmga_2"

while true
do
    echo "--- BẮT ĐẦU CHU KỲ MỚI ($(date)) ---"

    # 1. Dọn dẹp các tiến trình cũ
    pkill -f pinggy
    sleep 2

    # 2. Chạy lệnh Java (TCP) - Cổng API 4300
    ./pinggy -p 443 -R0:localhost:25565 tcp@free.pinggy.io > java_pinggy.log 2>&1 &
    
    # 3. Chạy lệnh Bedrock (UDP) - Cổng API 4301
    ./pinggy -p 443 -R0:localhost:25565 udp@free.pinggy.io --web-debug-port 4301 > bedrock_pinggy.log 2>&1 &

    echo "Đang đợi lấy dữ liệu từ Pinggy..."
    sleep 15

    # 4. Lấy IP Java và Bedrock
    JAVA_IP=$(curl -s http://localhost:4300/urls | grep -oE "[a-z0-9.-]+\.free\.pinggy\.io:[0-9]+")
    BEDROCK_RAW=$(curl -s http://localhost:4301/urls | grep -oE "[a-z0-9.-]+\.free\.pinggy\.io:[0-9]+")
    
    if [ -n "$JAVA_IP" ] && [ -n "$BEDROCK_RAW" ]; then
        B_HOST=$(echo $BEDROCK_RAW | cut -d':' -f1)
        B_PORT=$(echo $BEDROCK_RAW | cut -d':' -f2)

        # 5. Gửi Webhook báo THÀNH CÔNG
        curl -H "Content-Type: application/json" \
             -X POST \
             -d '{
          "content": "✅ **HỆ THỐNG ĐÃ KHỞI ĐỘNG THÀNH CÔNG!**",
          "embeds": [{
            "title": "🎮 THÔNG TIN MÁY CHỦ MINECRAFT",
            "description": "IP sẽ tự động thay đổi sau mỗi 60 phút để duy trì kết nối.",
            "color": 65280,
            "fields": [
              { "name": "☕ JAVA EDITION", "value": "IP: `'"$JAVA_IP"'`", "inline": false },
              { "name": "📱 BEDROCK EDITION", "value": "IP: `'"$B_HOST"'` \nPort: `'"$B_PORT"'`", "inline": false }
            ],
            "footer": { "text": "Trạng thái: Đang hoạt động ổn định" },
            "timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"
          }]
        }' $WEBHOOK_URL
        echo "Thành công: Đã gửi IP lên Discord."
    else
        echo "Lỗi: Không lấy được IP."
    fi

    echo "Sẽ khởi động lại sau 60 phút..."
    sleep 3600
done
EOF
