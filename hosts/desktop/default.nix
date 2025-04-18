# desktop.nix
# NOTE: This contains all common features I want only my desktop to have!

{ pkgs, inputs, config, host, ... }:
let
  username = config.myVars.username;
in
{
  myVars.username = "daniel";  # Specific username for this machine
  myVars.hostname = "desktop";  # Specific hostname for this machine
  myVars.isSyncthingClient = true;
  users.users.${username} = {
    description = "desktop";
  };

  myNixOS = {
    bundles.desktop-environment.enable = true;
    bundles.base-system.enable = true;
    virtualization.enable = false;
  };
  home-manager.users.${username}.myHomeManager = {
      bundles.desktop-environment.enable = true;
      bundles.coding-environment.enable = true;
  };

  time.hardwareClockInLocalTime = true;
  hardware.keyboard.zsa.enable = true;
  services = {
    xserver = {
      xkb = {
        options = "caps:swapescape";
      };
    };
    syncthing.guiAddress = "127.0.0.1:8385";
  };


}
