{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  username = config.myVars.username;
in {
  myNixOS = {
    firefox.enable = true;
  };

  environment.systemPackages = with pkgs; [
    xorg.xauth # for X11 forwarding.
  ];

  home-manager.users.${username} = {
    myHomeManager = {
      zed.enable = true;
    };
    home.packages = with pkgs; [
      # Sway/Wayland/Hyprland
      grim
      slurp
      wl-clipboard
      xclip
      xorg.xrandr
      wlprop
      pw-volume
      brightnessctl
      swappy
      # gui apps
      #qutebrowser-qt5
      #google-chrome
      zoom-us
      slack
      spotify
      kdePackages.okular
      plexamp
      libreoffice
      hunspell
      hunspellDicts.uk_UA
      hunspellDicts.th_TH
      # xournalpp
      feh
      # ardour # failed build?
      audacity
      vlc
      evince
      # Misc.
      bluez
      bluez-alsa
      bluez-tools
      imagemagick
    ];
  };
}
