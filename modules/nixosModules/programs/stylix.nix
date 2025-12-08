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
    defaultdark = {
      wallpaper = "theme-defaultdark-name-nixosblackgrey.jpg";
      scheme = "default-dark.yaml";
    };
    # gruvbox = {
    #   wallpaper = "theme-gruvbox-name-somename.jpg";
    #   scheme = "gruvbox-dark.yaml";
    # };
    nord = {
      wallpaper = "theme-nord-name-purplelogo.jpg";
      scheme = "nord.yaml";
    };
    atelier-forest = {
      wallpaper = "theme-atelierforest-name-hogwarts.jpg";
      scheme = "atelier-forest.yaml";
    };
    everforest = {
      wallpaper = "theme-everforest-name-ray.jpg";
      scheme = "everforest.yaml";
    };
    # Add more theme bundles as needed
  };

  # Map hosts to theme bundles
  hostThemes = {
    laptop = "catpuccin";
    living-room = "nord";
    desktop = "defaultdark";
    server = "defaultdark";
    persistent-usb = "everforest";
    # server = "gruvbox";
    # Add all your hosts here
  };

  # Get theme bundle for current host
  themeName = hostThemes.${host} or "defaultdark"; # fallback theme
  theme = themeBundles.${themeName};

  image = wallpaperDir + theme.wallpaper;
  base16Scheme = base16Dir + theme.scheme;
in {
  stylix = {
    enable = true;
    inherit image base16Scheme;
  };
}
