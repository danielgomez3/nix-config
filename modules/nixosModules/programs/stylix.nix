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
    # NOTE: Hogwarts
    # image = "${self.outPath}/modules/nixosModules/additional/wallpapers/hogwarts.jpg";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/woodland.yaml";
    # NOTE: Nord
    image = "${self.outPath}/modules/nixosModules/additional/wallpapers/nord-purple.jpg";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/monokai.yaml";
  };
}
