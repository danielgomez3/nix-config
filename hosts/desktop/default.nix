# desktop.nix
# NOTE: This contains all common features I want only my desktop to have!

{ pkgs, inputs, config, host, ... }:
let
  username = config.myVars.username;
in
{
  myVars.username = "daniel";  # Specific username for this machine
  myVars.isSyncthingClient = true;
  users.users.${username} = {
    description = "desktop";
  };

  myNixOS = {
    bundles.desktop-environment.enable = true;
    bundles.base-system.enable = true;
    virtualization.enable = true;
  };
  home-manager.users.${username}.myHomeManager = {
      bundles.desktop-environment.enable = true;
      bundles.coding-environment.enable = true;
  };

  time.hardwareClockInLocalTime = true;
  hardware.keyboard.zsa.enable = true;

  # NOTE: I bought a dedicated GPU
  # boot.blacklistedKernelModules = [
  #   # "iwlwifi"
  #   "rtw88_8821ce"
  # ];
  # NOTE: for brightness
  # boot.kernelParams = [
  #   "acpi_backlight=video"
  # ];

  services = {
    xserver = {
      xkb = {
        options = "caps:swapescape";
        # extraLayouts.${username} = {
        #   description = "Daniel's remapped keys";
        #   languages = ["eng"];
        #   symbolsFile = ./custom_symbols;
        # };
      };
    };
    syncthing.guiAddress = "127.0.0.1:8385";
  };


}
