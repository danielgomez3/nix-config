{ config, pkgs, lib, inputs, ... }:
{

  myHomeManager = {
    wezterm.enable = true;
    kitty.enable = true;
    zathura.enable = true;
    obs-studio.enable = true;
    emacs.enable = false;
    doom-emacs.enable = false;
    kdeconnect.enable = true;
  };

}
