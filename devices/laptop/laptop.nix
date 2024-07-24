# laptop.nix
# NOTE: This contains all common features I want only my laptop to have!

{ pkgs, inputs, username, host, ... }:

let 
  c_d = "configurations";
in
{
  imports =
    [ 
      ../${c_d}/all.nix
      ../${c_d}/gui.nix
      ../${c_d}/coding.nix
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

 # NOTE: Unique configuration.nix content for desktop:
  users.users.${username} = {
    description = "laptop";
  };
  services = {
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
    syncthing = {
      guiAddress = "127.0.0.1:8383";
    };
  };

  services.xserver = {
   # enable = true;
   xkb.options = "caps:swapescape";
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
