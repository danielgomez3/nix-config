{ config, lib, pkgs, self, ... }:
{
  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.secrets.tailscale.path;
  };
}
