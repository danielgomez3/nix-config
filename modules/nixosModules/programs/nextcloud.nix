# nextcloud.nix
{
  pkgs,
  lib,
  config,
  ...
}: let
  hostname = config.myVars.hostname;
in {
  # environment.etc."nextcloud-admin-pass".text = "MouseMouse!ThingWowLookit";
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud32;
    hostName = hostname;
    config.adminpassFile = config.sops.secrets."nextcloud-secret-pass".path;
    config.dbtype = "sqlite";
  };

  services.nginx.virtualHosts."${hostname}".listen = [
    {
      addr = "0.0.0.0";
      port = 9090;
    }
  ];
}
