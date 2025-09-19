{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.xkb.options = "caps:swapescape";

  systemd.services.NetworkManager-wait-online.enable = false; # HACK: This is giving me problems for some reason..

  environment.systemPackages = with pkgs; [
    gnomeExtensions.blur-my-shell
    gnomeExtensions.pop-shell
    gnomeExtensions.hide-top-bar
    # gnomeExtensions.pano
    # gnomeExtensions.clipboard-indicator
  ];
  home-manager.users.${config.myVars.username} = {
    dconf.enable = true;
    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false; # enables user extensions
        enabled-extensions = [
          pkgs.gnomeExtensions.blur-my-shell.extensionUuid
          pkgs.gnomeExtensions.pop-shell.extensionUuid
          pkgs.gnomeExtensions.hide-top-bar.extensionUuid
          # pkgs.gnomeExtensions.pano.extensionUuid
          # pkgs.gnomeExtensions.clipboard-indicator.extensionUuid
        ];

        # Pressing super key will show shortcut for the following:
        favorite-apps = [
          "org.kde.okular.desktop"
          "org.gnome.Nautilus.desktop" # File manager
        ];
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

      "org/gnome/shell/extensions/pop-shell" = {
        tile-by-default = true;
      };

      "org/gnome/desktop/wm/preferences" = {
        focus-mode = "mouse";
        # resize-with-right-button = true;
      };

      "org/gnome/shell/extensions/hidetopbar" = {
        enable-active-window = false;
        enable-intellihide = false;
      };

      # "org/gnome/settings-daemon/plugins/power" = {
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
}
