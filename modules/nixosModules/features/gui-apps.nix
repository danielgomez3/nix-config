{ config, pkgs, lib, inputs, ... }:
let
  username = config.myVars.username;
in
{

  environment.systemPackages = with pkgs; [
    xorg.xauth  # for X11 forwarding.
  ];

  home-manager.users.${username} = {
    home.packages = with pkgs; [
        # Sway/Wayland/Hyprland
        grim slurp wl-clipboard xclip xorg.xrandr swayidle swaylock flashfocus autotiling sway-contrib.grimshot wlprop pw-volume 
        # adwaita-icon-theme adwaita-qt 
        brightnessctl swappy dmenu
        # hyprland
        waybar eww wofi
        # gui apps
        firefox zoom-us slack spotify okular plexamp
        libreoffice hunspell hunspellDicts.uk_UA hunspellDicts.th_TH
        cmus xournalpp 
        feh ardour audacity vlc evince
        # Misc.
        bluez bluez-alsa bluez-tools
        imagemagick
    ];
  };

}

