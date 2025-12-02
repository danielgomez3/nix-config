#
# jovian.nix -- Gaming
# https://ciarandegroot.com/archive/nixos-steam-box/
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  # Local user account for auto login
  # Separate and distinct from Steam login
  # Can be any name you like
in {
  #
  # Imports
  #
  imports = [
    inputs.jovian.nixosModules.default
  ];

  #
  # Dependencies
  #
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;

  #
  # Boot
  #

  #
  # Hardware
  #
  hardware.xone.enable = true;

  #
  # Jovian
  #
  jovian.hardware.has.amd.gpu = true;

  # jovian.steam = {
  #   enable = true;
  #   autoStart = true;
  # };

  services.desktopManager.plasma6.enable = false;
  services.displayManager.gdm.enable = lib.mkForce false;

  # environment.variables.GDK_SCALE = "2";
  jovian = {
    steamos = {
      useSteamOSConfig = true;
    };
    steam = {
      enable = true;
      autoStart = true;
      updater.splash = "steamos";
      user = "${config.myVars.username}";
      # desktopSession = "gamescope-wayland";
      desktopSession = "gnome";
    };
    # decky-loader = {
    #   enable = true;
    #   extraPackages = [];
    #   # extraPythonPackages = [];
    #   stateDir = "/var/lib/decky-loader";
    #   user = "${config.myVars.username}";
    # };
    devices = {
      steamdeck = {
        autoUpdate = true;
      };
    };
  };

  #
  # Packages
  #
  environment.systemPackages = with pkgs; [
    cmake # Cross-platform, open-source build system generator
    steam-rom-manager # App for adding 3rd party games/ROMs as Steam launch items
  ];

  #
  # SDDM
  #
  services.displayManager.sddm.settings = {
    Autologin = {
      Session = "gamescope-wayland.desktop";
      User = "${config.myVars.username}";
    };
  };

  #
  # Steam
  #
  # Set game launcher: gamemoderun %command%
  #   Set this for each game in Steam, if the game could benefit from a minor
  #   performance tweak: YOUR_GAME > Properties > General > Launch > Options
  #   It's a modest tweak that may not be needed. Jovian is optimized for
  #   high performance by default.
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility"; # For systems with AMD GPUs
        gpu_device = 0;
        amd_performance_level = "high";
      };
    };
  };

  programs.steam = {
    enable = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  #
  # Users
  #
  users = {
    groups.${config.myVars.username} = {
      name = "${config.myVars.username}";
      gid = 10000;
    };

    # Generate hashed password: mkpasswd -m sha-512
    # hashedPassword sets the initial password. Use `passwd` to change it.
    users.${config.myVars.username} = {
      extraGroups = ["gamemode" "networkmanager"];
      group = "${config.myVars.username}";
      home = "/home/${config.myVars.username}";
      isNormalUser = true;
      uid = 10000;
    };
  };

  #
  # Boot
  #
  boot = {
    consoleLogLevel = 0;

    initrd.verbose = false;

    kernelPackages = pkgs.linuxPackages_latest;

    # Quiet, graphical boot
    kernelParams = [
      "quiet"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        configurationLimit = 10;
        enable = true;
      };

      timeout = 5;
    };

    plymouth.enable = true; # Splash screen
  };

  #
  # Nix
  #
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 60d";
    };
  };

  #
  # System
  #
  system = {
    activationScripts = {
      # Print a summary of nixos-rebuild changes
      diff = {
        supportsDryActivation = true;
        text = ''
          ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff \
            /run/current-system "$systemConfig"
        '';
      };
    };
  };
}
