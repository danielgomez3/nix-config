# https://github.com/MatthewCroughan/NixThePlanet/tree/master
# Module options: https://github.com/MatthewCroughan/NixThePlanet/blob/master/makeDarwinImage/module.nix

# systemctl status macos-ventura
# connect via: vncviewer server:5901
{inputs,...}:{
  imports = [ inputs.nixtheplanet.nixosModules.macos-ventura];
  services.macos-ventura = {
    enable = true;
    openFirewall = true;
    vncListenAddr = "0.0.0.0";
    vncDisplayNumber = 1;
  };
}
