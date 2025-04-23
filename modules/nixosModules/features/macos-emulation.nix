# https://github.com/MatthewCroughan/NixThePlanet/tree/master
# Module options: https://github.com/MatthewCroughan/NixThePlanet/blob/master/makeDarwinImage/module.nix
{inputs,...}:{
  import = [ inputs.nixtheplanet.nixosModules.macos-ventura];
  services.macos-ventura = {
    enable = true;
    openFirewall = true;
    vncListenAddr = "0.0.0.0";
  };
}
