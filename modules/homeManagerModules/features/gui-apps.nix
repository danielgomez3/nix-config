{ config, pkgs, lib, inputs, ... }:
let
  username = config.myVars.username;
in
{

  myHomeManager = {
    wezterm.enable = true;
    kitty.enable = true;
    zathura.enable = true;
    obs-studio.enable = true;
    emacs.enable = true;
  };

}
