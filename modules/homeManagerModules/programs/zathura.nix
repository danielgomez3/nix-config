{ config, lib, pkgs, ... }:
{
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      scroll-step = 50;
    };
    # extraConfig = 
    # ''
    #     # Clipboard
    #     set selection-clipboard clipboard
    #     set scroll-step 50
    # '';
  };
}
