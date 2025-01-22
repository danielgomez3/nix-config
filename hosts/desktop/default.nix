# desktop.nix
# NOTE: This contains all common features I want only my desktop to have!

{ pkgs, inputs, config, host, ... }:
let
  username = config.myVars.username;
in
{
  myVars.username = "daniel";  # Specific username for this machine
  users.users.${username} = {
    description = "desktop";
  };
  myNixOS = {
    bundles.desktop-environment.enable = true;
    bundles.base-system.enable = true;
  };
  time.hardwareClockInLocalTime = true;
  hardware.keyboard.zsa.enable = true;

  # NOTE: I bought a dedicated GPU
  # boot.blacklistedKernelModules = [
  #   # "iwlwifi"
  #   "rtw88_8821ce"
  # ];
  boot.kernelParams = [
    "amdgpu.backlight=0"
    "acpi_backlight=none"
  ];

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


  home-manager.users.${username} = {
    myHomeManager = {
      # gui-apps.enable = true;
      # cli-apps.enable = true;
      bundles.desktop-environment.enable = true;
    };
    wayland.windowManager.sway = {
      extraConfig = ''
      output HDMI-A-1 scale 2
      '';
      config = {
        startup = [
          { command = "kdeconnect-sms"; }
          { command = "plexamp"; }
        ];
      };
    };
  };
}
