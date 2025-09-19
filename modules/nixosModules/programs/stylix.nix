{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  stylix = {
    enable = true;

    # TODO: Maybe make a new dir? Or maybe make this path more pure with a variable.
    # image = "${self.outPath}/modules/nixosModules/additional/wallpapers/rose-pine-cat.png";
    image = "${self.outPath}/modules/nixosModules/additional/wallpapers/ice-pink.png";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    # programs.firefox.enable = true;
  };
}
