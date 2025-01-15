{ config, lib, pkgs, self, ... }:
{
  stylix = {
    enable = true;
    # TODO: Maybe make a new dir? Or maybe make this path more pure with a variable.
    image = "${self.outPath}/modules/nixosModules/additional/wallpapers/pink-pastel.jpg";
    # image = ../additional/wallpapers/white.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox.yaml";
    # cursor = { 
    #   package = pkgs.bibata-cursors; 
    #   name = "Bibata-Modern-Ice";
    #   # size = 50;
    # };
    # targets.nixvim.enable = false;
    # fonts = {
    #   monospace = {
    #     package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
    #     name = "JetBrainsMono Nerd Font Mono";
    #   };
    #   sansSerif = {
    #     package = pkgs.dejavu_fonts;
    #     name = "DejaVu Sans";
    #   };
    #   serif = {
    #     package = pkgs.dejavu_fonts;
    #     name = "DejaVu Serif";
    #   };
    # };
    # targets = {
    #   helix.enable = true;
    #   sway.enable = true;
    #   swaylock.enable = true;
    #   wezterm.enable = true;
    # };
  };
}
