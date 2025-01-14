{ config, lib, pkgs, self, ... }:
{
  programs.obs-studio = {
    enable = true;
  };
}
