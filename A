{ pkgs, ... }: {
  channel = "stable-23.11";

  # Chỉ cài đặt các gói công cụ, không tự động chạy gì cả
  packages = [
    # Công cụ hệ thống & Giải nén
    pkgs.curl
    pkgs.wget
    pkgs.unzip
    pkgs.gnutar
    pkgs.gzip
    
    # Môi trường lập trình & Chạy ứng dụng
    pkgs.nodejs_20
    pkgs.go
    pkgs.gcc
    pkgs.openssh
    
    # Công cụ mở Port (Tunneling)
    pkgs.cloudflared
  ];

  idx = {
    # Bật tính năng Preview nếu bạn muốn xem web qua cổng 8080 của IDX
    previews = {
      enable = true;
      previews = {
        web = {
          command = ["sleep" "infinity"]; # Giữ preview không bị lỗi khi chưa chạy panel
          manager = "web";
        };
      };
    };

    # Không tự động chạy lệnh cài đặt hay tiến trình nào
    onCreate = {};
    processes = {};
  };
}
