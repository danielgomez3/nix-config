{ config, lib, pkgs, self, ... }:
{
  tailscale = {
    enable = true;
    # authKeyFile = config.sops.secrets.tailscale.path;
  };
}
