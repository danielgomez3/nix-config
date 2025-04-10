# https://nixos.wiki/wiki/Static_Web_Server

{config,pkgs,lib,...}:{

  # NOTE: We need to create this dir first, or make sure it exists:
  systemd.tmpfiles.rules = [
    "d /var/www 0755 staticweb staticweb -"
  ];
  # NOTE: And create a user with limited permissions:
  users.users.staticweb = {
    isSystemUser = true;
    group = "staticweb";
  };

  # NOTE: By default, this will start SWS on [::]:8787
  # sudo systemctl status static-web-server.service
  services.static-web-server = {
    enable = true;
    root = "/var/www";
  };

}
