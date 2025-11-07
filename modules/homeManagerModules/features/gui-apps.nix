{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  myHomeManager = {
    wezterm.enable = true;
    kitty.enable = true;
    zathura.enable = true;
    obs-studio.enable = true;
    kdeconnect.enable = true;
    # firefox.enable = false;
    mangohud.enable = true;
    thunderbird.enable = true;
  };
}
