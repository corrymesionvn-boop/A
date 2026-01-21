cat << 'EOF' > start.sh
#!/bin/bash

# --- CẤU HÌNH ---
WEBHOOK_URL="https://discord.com/api/webhooks/1460633815578968239/E5Ck-CCpCwQNUtGXA9z-VpWwcQzZz7M7meSapdb8i7f0cZ_XdnOg4EHeCQ6x4rfmga_2"

while true
do
    echo "--- BẮT ĐẦU CHU KỲ MỚI ($(date)) ---"

    # 1. Dọn dẹp tiến trình cũ
    pkill -9 -f pinggy
    sleep 3

    # 2. Khởi động Pinggy (Thêm --no-tui để fix lỗi giao diện)
    ./pinggy -p 443 -R0:localhost:25565 tcp@free.pinggy.io --noupdate --no-tui > java_pinggy.log 2>&1 &
    ./pinggy -p 443 -R0:localhost:25565 udp@free.pinggy.io --web-debug-port 4301 --noupdate --no-tui > bedrock_pinggy.log 2>&1 &

    echo "Đang đợi Pinggy kết nối..."
    sleep 30

    # 3. Lấy IP (Hỗ trợ cả đuôi .io và .link)
    JAVA_IP=$(curl -s http://localhost:4300/urls | grep -oE "[a-z0-9.-]+\.free\.pinggy\.(io|link):[0-9]+" | head -n 1)
    BEDROCK_RAW=$(curl -s http://localhost:4301/urls | grep -oE "[a-z0-9.-]+\.free\.pinggy\.(io|link):[0-9]+" | head -n 1)

    if [ -n "$JAVA_IP" ] && [ -n "$BEDROCK_RAW" ]; then
        B_HOST=$(echo $BEDROCK_RAW | cut -d':' -f1)
        B_PORT=$(echo $BEDROCK_RAW | cut -d':' -f2)

        # 4. Gửi Webhook
        curl -H "Content-Type: application/json" -X POST -d '{
          "content": "✅ **HỆ THỐNG ĐÃ KHỞI ĐỘNG THÀNH CÔNG!**",
          "embeds": [{
            "title": "🎮 MINECRAFT SERVER IP",
            "color": 65280,
            "fields": [
              { "name": "☕ Java Edition", "value": "IP: `'"$JAVA_IP"'`" },
              { "name": "📱 Bedrock Edition", "value": "IP: `'"$B_HOST"'` \nPort: `'"$B_PORT"'`" }
            ],
            "footer": { "text": "Hệ thống tự động reset sau mỗi 60 phút" }
          }]
        }' $WEBHOOK_URL
        echo "✅ Thành công!"
    else
        echo "❌ Vẫn không lấy được IP. Thử lại sau 1 phút..."
        sleep 60
        continue
    fi

    sleep 3600
done
EOF
