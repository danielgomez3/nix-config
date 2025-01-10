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
  config.myNixOS = {
    all.enable = true;
    sops.enable = true;
    internet.enable = true;
    coding.enable = true;
    virtualization.enable = false;
  };
}
