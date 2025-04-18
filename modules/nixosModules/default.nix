# imports = [ ./username.nix ./coding.nix ./gui.nix ./all.nix ./virtualization.nix ];
{ myHelper, config, pkgs, lib, inputs,  name, ... }:
let
  # cfg = config.services.all;  # My custom service called 'all'
  cfg = config.myNixOS;

  features =
    myHelper.extendModules
    (name: {
      extraOptions = {
        myNixOS.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
      };

      configExtension = config: (lib.mkIf cfg.${name}.enable config);
    })
    (myHelper.filesIn ./features);

    bundles =
      myHelper.extendModules
      (name: {
        extraOptions = {
          myNixOS.bundles.${name}.enable = lib.mkEnableOption "enable ${name} module bundle";
        };

        configExtension = config: (lib.mkIf cfg.bundles.${name}.enable config);
      })
      (myHelper.filesIn ./bundles);

   programs =
      myHelper.extendModules
      (name: {
        extraOptions = {
          myNixOS.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
        };

        configExtension = config: (lib.mkIf cfg.${name}.enable config);
      })
      (myHelper.filesIn ./programs);

in
{
  imports = [ ] ++ features ++ programs ++ bundles;
}
