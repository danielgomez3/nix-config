# imports = [ ./username.nix ./coding.nix ./gui.nix ./all.nix ./virtualization.nix ];
{ myLib, config, pkgs, lib, inputs,  name, ... }:
let
  # cfg = config.services.all;  # My custom service called 'all'
  cfg = config.myNixOS;
  features =
    myLib.extendModules
    (name: {
      extraOptions = {
        myNixOS.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
      };

      configExtension = config: (lib.mkIf cfg.${name}.enable config);
    })
    (myLib.filesIn ./features);
   programs =
      myLib.extendModules
      (name: {
        extraOptions = {
          myNixOS.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
        };

        configExtension = config: (lib.mkIf cfg.${name}.enable config);
      })
      (myLib.filesIn ./programs);
in
{
  imports = [ ] ++ features ++ programs;
  system.stateVersion = "24.05"; 
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  config.myNixOS = {
    all.enable = true;
    internet.enable = true;
    coding.enable = true;
    virtualization.enable = false;
    sops.enable = true;
    stylix.enable = true;
    syncthing.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
  };
}
