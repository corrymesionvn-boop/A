#!/bin/bash

# 1. Dọn dẹp các session cũ
tmux kill-session -t java_link 2>/dev/null
tmux kill-session -t bedrock_link 2>/dev/null
pkill -f "ssh -p 443"
sleep 2

# 2. Cấu hình các tham số SSH
SSH_OPTS="-p 443 -o StrictHostKeyChecking=no -o ServerAliveInterval=30 -o ServerAliveCountMax=120"

echo "🚀 Đang khởi động Java với Token..."
# Lưu ý: Cú pháp chuẩn của Pinggy là Token+tcp@...
tmux new-session -d -s java_link "ssh $SSH_OPTS -R0:127.0.0.1:25565 pt70EXJbPWH+tcp@ap.free.pinggy.io"

sleep 10 # Nghỉ một lát để tunnel thứ nhất ổn định

echo "🚀 Đang khởi động Bedrock với Token..."
# Đổi port local về 8000 để khớp với server Bedrock của bạn
tmux new-session -d -s bedrock_link "ssh $SSH_OPTS -R0:127.0.0.1:25565 pt70EXJbPWH+udp@ap.free.pinggy.io"

echo "✅ Đã kích hoạt xong. IP bây giờ sẽ rất ổn định!"
