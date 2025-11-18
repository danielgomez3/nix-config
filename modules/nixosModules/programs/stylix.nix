{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  stylix = {
    enable = true;

    # image = "${self.outPath}/modules/nixosModules/additional/wallpapers/nixlogo-bluepink-background-blue.png";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";

    image = "${self.outPath}/modules/nixosModules/additional/wallpapers/theme-darktooth-name-nixosblackgrey.jpg";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/default-dark.yaml";
  };
}
