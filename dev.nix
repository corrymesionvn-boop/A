{ pkgs, ... }: {
  # Cấu hình kênh gói phần mềm
  channel = "stable-23.11";

  # Danh sách các gói cài đặt vào môi trường
  packages = [
    pkgs.curl
    pkgs.wget
    pkgs.unzip          # Để bạn giải nén backup
    pkgs.gnutar
    pkgs.gzip
    pkgs.nodejs_20      # Node.js
    pkgs.go             # Go (cần cho PufferPanel)
    pkgs.openssh        # Để dùng Pinggy nếu cần
    pkgs.cloudflared    # Để dùng Cloudflare Tunnel
  ];

  # Cấu hình của Google IDX
  idx = {
    # Cài đặt các Extension (để trống nếu không dùng)
    extensions = [ ];

    # Quản lý các tiến trình (Đã tắt tự động theo ý bạn)
    processes = { };

    # Cấu hình xem trước (Preview)
    previews = {
      enable = true;
      previews = {
        web = {
          # Cổng mặc định của PufferPanel là 8080
          command = [ "echo" "Môi trường đã sẵn sàng. Hãy chạy panel trong Terminal!" ];
          manager = "web";
        };
      };
    };
  };
}
    processes = {};
  };
}
