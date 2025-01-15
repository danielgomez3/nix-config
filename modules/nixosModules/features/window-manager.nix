{ config, pkgs, lib, inputs, ... }:
let
  modKey = "Mod4";
  username = config.myVars.username;
in
{
  
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # Brighness and volume <https://nixos.wiki/wiki/Sway>
  users.users.${username}.extraGroups = [ "video" ];
  programs = {
    light.enable = true;
  };

  security.rtkit.enable = true;  # Necessary for Pipewire

  # For Wayland/Sway screen-sharing:
  xdg.portal = {
    config.common.default = "*";
    enable = true;
    wlr = {
      enable = true;
      settings = {
        screencast = {
          max_fps = 15;
          chooser_type = "dmenu";
          chooser_cmd = "${pkgs.wofi}/bin/wofi --show dmenu";
        };
      };
    };
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  services = { 
    gnome.gnome-online-accounts.enable = true;
    gnome.gnome-keyring.enable = true;

  };

  # hardware.graphics.enable = true;  # NOTE: Enable this if you have problems with sway
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };
  security.pam.loginLimits = [
    { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      # (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Source Han Serif" ];
      sansSerif = [ "Noto Sans" "Source Han Sans" ];
    };
  };

}
