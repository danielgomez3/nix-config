# laptop.nix
# NOTE: This contains all common features I want only my laptop to have!

{ config, pkgs, inputs, host, lib, name, ... }:

let 
  modKey = "Mod4";
  username = config.myVars.username;
in
{
  myVars.username = "daniel";  # Specific username for this machine
  myVars.isHardwareLimited = true;
  myVars.isSyncthingClient = true;

  users.users.${username} = {
    description = "laptop";
  };

  myNixOS = {
    bundles.desktop-environment.enable = true;
    bundles.base-system.enable = true;
  };

  services = {
    libinput.touchpad.disableWhileTyping = true;
    # tlp = {
    #   enable = true;
    #   settings = {
    #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
    #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

    #     CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

    #     CPU_MIN_PERF_ON_AC = 0;
    #     CPU_MAX_PERF_ON_AC = 100;
    #     CPU_MIN_PERF_ON_BAT = 0;
    #     CPU_MAX_PERF_ON_BAT = 20;

    #    #Optional helps save long term battery health
    #    START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
    #    STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    #   };
    # };
    syncthing = {
      guiAddress = "127.0.0.1:8383";
    };
  };

  services.xserver = {
   xkb.options = "caps:swapescape";
  };


  home-manager.users.${username}.myHomeManager = {
        bundles.desktop-environment.enable = true;
  };

}
