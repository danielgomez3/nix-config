{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  caffeine = pkgs.gnomeExtensions.caffeine.overrideAttrs (oldAttrs: {
    version = "59"; # Specify the desired version
    src = pkgs.fetchurl {
      url = "https://github.com/eonpatapon/gnome-shell-extension-caffeine/archive/refs/tags/v59.tar.gz";
      sha256 = "sha256-dNjq1pdZeyChGVjNXmc6MPjw/71yyC86bhV9V0tNxbI=; # Replace with the actual SHA256";
    };
  });
in {
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # To disable installing GNOME's suite of applications
  # and only be left with GNOME shell.
  services.gnome.core-apps.enable = true;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;
  environment.gnome.excludePackages = with pkgs; [gnome-tour gnome-user-docs];

  services.xserver.xkb.options = "caps:swapescape";

  systemd.services.NetworkManager-wait-online.enable = false; # HACK: This is giving me problems for some reason..

  environment.systemPackages = with pkgs; [
    nautilus
    gnome-sound-recorder
    gnomeExtensions.blur-my-shell
    gnomeExtensions.pop-shell
    # gnomeExtensions.hide-top-bar
    gnomeExtensions.blurt
    gnomeExtensions.caffeine
    gnomeExtensions.keep-awake
    # gnomeExtensions.arc-menu
  ];
  home-manager.users.${config.myVars.username} = {
    dconf.enable = true;
    dconf.settings = {
      "org/gnome/shell" = {
        last-selected-power-profile = "performance";
        disable-user-extensions = false; # enables user extensions
        enabled-extensions = [
          pkgs.gnomeExtensions.blur-my-shell.extensionUuid
          pkgs.gnomeExtensions.pop-shell.extensionUuid
          # pkgs.gnomeExtensions.hide-top-bar.extensionUuid
          pkgs.gnomeExtensions.blurt.extensionUuid
          pkgs.gnomeExtensions.caffeine.extensionUuid
          pkgs.gnomeExtensions.keep-awake.extensionUuid
          # pkgs.gnomeExtensions.arc-menu.extensionUuid
        ];

        # Pressing super key will show shortcut for the following:
        favorite-apps = [
          "org.kde.okular.desktop"
          "org.gnome.Nautilus.desktop" # File manager
        ];
      };

      "org/gnome/desktop/session" = {
        # idle-delay = "uint32 900";
        idle-delay = lib.gvariant.mkUint32 900; # Example: 300 seconds = 5 minutes
      };

      "org/gnome/desktop/peripherals/touchpad" = lib.mkIf config.myVars.isHardwareLimited {
        speed = 0.8;
      };

      # "org/gnome/shell/extensions/clipboard-indicator" = {
      #   clear-on-boot = true;
      #   confirm-clear = false;
      #   # display-mode = 0;
      #   # enable-keybindings = false;
      #   # history-size = 10;
      #   # strip-text = true;
      #   toggle-menu = ["<Super>c"];
      # };

      "org/gnome/desktop/wm/preferences" = {
        focus-mode = "mouse";
        # resize-with-right-button = true;
      };

      "org/gnome/shell/extensions/pop-shell" = {
        tile-by-default = true;
      };

      "org/gnome/shell/extensions/caffeine" = {
        user-enabled = true;
        show-indicator = "always";
        screen-blank = "always";
      };

      # "org/gnome/shell/extensions/hidetopbar" = {
      #   enable-active-window = false;
      #   enable-intellihide = false;
      # };

      # TODO: change conditionaly for laptop and desktop
      # "org/gnome/settings-daemon/plugins/power" = {
      #   power-mode = "performance";
      #   power-button-action = "hibernate";
      #   # Hibernate after 900 seconds running only battery
      #   sleep-inactive-battery-timeout = 900;
      #   sleep-inactive-battery-type = "hibernate";
      # };

      # "org/gnome/shell/extensions/pano" = {
      #   # TODO: declaratively enable 'paste on select'. You did so imperatively.
      #   # global-shortcut = ["<Super>comma"];
      #   global-shortcut = ["<Control><Super>v"];
      #   incognito-shortcut = ["<Shift><Super>less"];
      #   # play-audio-on-copy = false;
      #   # send-notification-on-copy = false;
      #   # paste-on-select = false;
      # };

      # "org/gnome/desktop/peripherals/touchpad" = {
      #   speed = 0.9;
      # };
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };
}
