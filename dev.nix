{ pkgs, ... }: {
  channel = "stable-23.11";

  packages = [
    pkgs.unzip
    pkgs.curl
    pkgs.wget
    pkgs.nodejs_20
    pkgs.cloudflared
    pkgs.openssh
    pkgs.gnutar
  ];

  idx = {
    extensions = [ ];
    previews = { };
  };
}
