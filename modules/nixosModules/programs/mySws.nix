# mySws.nix
# TODO: SSL certificatation
# TODO: an alternative would be a download hash, just to learn about those!
# https://nixos.wiki/wiki/Static_Web_Server
{
  self,
  config,
  pkgs,
  lib,
  ...
}: let
  myWebsite = pkgs.callPackage "${self.outPath}/derivations/mySws" {};
in {
  # NOTE: We need to create this dir first, or make sure it exists:
  systemd.tmpfiles.rules = [
    "d /var/www 0755 staticweb staticweb -"
  ];

  # NOTE: By default, this will start SWS on [::]:8787
  # sudo systemctl status static-web-server.service
  services.static-web-server = {
    enable = true;
    # listen = "[::]:80";
    root = "/var/www"; # FIXME: let's do the nix store instead
    # root = "${myWebsite}";  # Serve directly from the Nix store
    configuration = {
      general = {
        directory-listing = true;
        log-level = "error";
      };
    };
  };
}
