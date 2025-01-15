{ config, pkgs, lib, inputs, ... }:
{

  myHomeManager = {
    sway.enable = true;
    wezterm.enable = true;
    kitty.enable = true;
    zathura.enable = true;
    obs-studio.enable = true;
    emacs.enable = true;
  };

}
