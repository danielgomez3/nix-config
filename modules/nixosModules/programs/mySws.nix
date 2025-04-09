# https://nixos.wiki/wiki/Static_Web_Server

{config,pkgs,lib,...}:{

  # NOTE: By default, this will start SWS on [::]:8787
  # sudo systemctl status static-web-server.service
  services.static-web-server = {
    enable = true;
    root = "/var/www";
  };

}
