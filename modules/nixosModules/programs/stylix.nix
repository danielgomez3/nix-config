{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  host = config.myVars.hostname;
  wallpaperDir = "${self.outPath}/modules/nixosModules/additional/wallpapers/";
  base16Dir = "${pkgs.base16-schemes}/share/themes/";

  # Define theme bundles
  themeBundles = {
    catpuccin = {
      wallpaper = "theme-catpuccinlatte-name-bluepinknixlogo.png";
      scheme = "catppuccin-frappe.yaml";
    };
    darktooth = {
      wallpaper = "theme-darktooth-name-nixosblackgrey.jpg";
      scheme = "darktooth.yaml";
    };
    # gruvbox = {
    #   wallpaper = "theme-gruvbox-name-somename.jpg";
    #   scheme = "gruvbox-dark.yaml";
    # };
    # nord = {
    #   wallpaper = "theme-nord-name-somename.jpg";
    #   scheme = "nord.yaml";
    # };
    # Add more theme bundles as needed
  };

  # Map hosts to theme bundles
  hostThemes = {
    laptop = "catpuccin";
    desktop = "darktooth";
    workstation = "nord";
    server = "gruvbox";
    # Add all your hosts here
  };

  # Get theme bundle for current host
  themeName = hostThemes.${host} or "darktooth"; # fallback theme
  theme = themeBundles.${themeName};

  image = wallpaperDir + theme.wallpaper;
  base16Scheme = base16Dir + theme.scheme;
in {
  stylix = {
    enable = true;
    inherit image base16Scheme;
  };
}
