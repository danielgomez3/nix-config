# laptop.nix
# NOTE: This contains all common features I want only my laptop to have!

{ config, pkgs, inputs, host, lib, name, ... }:

let 
  modKey = "Mod4";
  username = config.myConfig.username;
in
{
  myConfig.username = "daniel";  # Specific username for this machine

  users.users.${username} = {
    description = "laptop";
  };

  myNixOS = {
    all.enable = true;
    desktop-environment.enable = true;
    desktop-apps.enable = true;
    coding.enable = true;
    virtualization.enable = false;
  };

  services = {
    tailscale = {
      authKeyFile = config.sops.secrets.tailscale.path;
    };
    syncthing = {
      guiAddress = "127.0.0.1:8383";
    };
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

       #Optional helps save long term battery health
       START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
       STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
      };
    };
  };

  services.xserver = {
   # enable = true;
   xkb.options = "caps:swapescape";
  };

  networking = {
    wireless.iwd = {
      enable = true;
      settings = {
        IPv6 = {
          Enabled = true;
        };
        Settings = {
          AutoConnect = true;
        };
      };
    };
  };

  home-manager.users.${username} = {
      wayland.windowManager.sway = {
        extraConfig = ''
          ## Sleep
          exec swayidle -w \
          	timeout 320 'swaylock -c 000000 -f' \
          	timeout 350 'swaymsg "output * power off"' \
          	resume 'swaymsg "output * power on"'
        '';
      };
      wayland.windowManager.hyprland = {
        settings = {
          input =  {
            "kb_options" = "caps:swapescape";
          };
        };
      };
  };

  # NOTE: Unique home-manager config for laptop:
  # home-manager = { 
  #   extraSpecialArgs = { inherit inputs; };
  #   users.${username} = {
  #     programs = with pkgs; {
  #       kitty = {
  #         font = {
  #           size = 14;
  #         };
  #       };
  #     };
  #   };
  # };





  }
