# configuration.nix
# NOTE: Ubiquitous configuration.nix and home-manager content for all systems:

# Edit this configuration file tco define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ self, config, pkgs, lib, inputs,  name, ... }:
let 
  # nvChad = import ./derivations/nvchad.nix { inherit pkgs; };
  # cutefetch = import ./derivations/cutefetch.nix { inherit pkgs; };  # FIX attempting w/home-manager
  username = config.myVars.username;
in
{

  # A custom 'service' called 'all'. If a system has this enabled, it will inherit the following settings!:

    swapDevices = [{
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }];
    nixpkgs.config.allowUnfree = true;
    # nix.settings = {
    #   substituters. ["https://hyprland.cachix.org"];
    #   trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    # };

    # https://wiki.nixos.org/wiki/Syncthing#tips
    # Don't create default ~/Sync folder
    systemd.services = {
      syncthing.environment.STNODEFAULTFOLDER = "true";  
    };

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 3;
    };


    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };



    users = {
      # Define a user account. Don't forget to set a password with ‘passwd’.
      mutableUsers = false;  # Required for a password 'passwd' to be set via sops during system activation (over anything done imperatively)!
      users.root = {
        hashedPasswordFile = config.sops.secrets.user_password.path;  
        openssh.authorizedKeys.keys = [
          (builtins.readFile "${self.outPath}/hosts/desktop/key.pub")
          (builtins.readFile "${self.outPath}/hosts/server/key.pub")
          (builtins.readFile "${self.outPath}/hosts/laptop/key.pub")
        ];
      };

      users.${username} = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets.user_password.path;  # Shoutout to sops baby.
        # password = "123";
        extraGroups = [ "wheel" ];
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
        # FIXME: relative imports
        openssh.authorizedKeys.keys = [
          # Needed for personal use, to ssh and do some normal user work.
          (builtins.readFile "${self.outPath}/hosts/desktop/key.pub")
          (builtins.readFile "${self.outPath}/hosts/server/key.pub")
          (builtins.readFile "${self.outPath}/hosts/laptop/key.pub")
          # Needed for Colmena b/c doesn't use root for colmena?
          (builtins.readFile "${self.outPath}/hosts/desktop/root-key.pub")
          (builtins.readFile "${self.outPath}/hosts/laptop/root-key.pub")
          (builtins.readFile "${self.outPath}/hosts/server/root-key.pub")
        ];
      };
    };
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment = {
      # sessionVariables = {
      #   GITHUB_TOKEN = config.sops.secrets.github_token.path;  
      #   GITHUB_TOKEN = "$(cat ${config.sops.secrets.github_token.path})";
      # };
      systemPackages = with pkgs; [
        # linux linux-firmware
        git wget curl pigz 
        lm_sensors 
        woeusb ntfs3g 
        iptables nftables file toybox 
        waypipe # x11 forwarding alternative:
        # Security
        gnupg pinentry-tty age yubioath-flutter yubikey-manager pam_u2f
      ];
    };

    # Yubikey required services and config.
    # services.udev.packages = [ pkgs.yubikey-personalization ];

    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # services.pcscd.enable = true;
    # services.udev.packages = [ pkgs.yubikey-personalization ];
    # services.yubikey-agent.enable = true;
    # security.pam = {
    #   sshAgentAuth.enable = true;
    #   u2f = {
    #     enable = true;
    #     settings = {
    #       cue = true;
    #       authFile = "/home/${username}/.config/Yubico/u2f_keys";
    #     };
    #   };
    #   services = {
    #     login.u2fAuth = true;
    #     sudo = {
    #       u2fAuth = true;
    #       sshAgentAuth = true; # Use SSH_AUTH_SOCK for sudo
    #     };
    #   };
    # };

}
