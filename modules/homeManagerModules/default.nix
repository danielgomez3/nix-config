{
  pkgs,
  system,
  inputs,
  config,
  lib,
  myLib,
  ...
}: let
  cfg = config.home-manager.users.${username}.myHomeManager;
  username = config.myVars.username;


  # Taking all modules in ./features and adding enables to them
  # features =
  #   myLib.extendModules
  #   (name: {
  #     extraOptions = {
  #       myHomeManager.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
  #     };

  #     configExtension = config: (lib.mkIf cfg.${name}.enable config);
  #   })
  #   (myLib.filesIn ./features);

  programs =
    myLib.extendModules
    (name: {
      extraOptions = {
        myHomeManager.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
      };

      configExtension = config: (lib.mkIf cfg.${name}.enable config);
    })
    (myLib.filesIn ./programs);

  # Taking all module bundles in ./bundles and adding bundle.enables to them
  # bundles =
  #   myLib.extendModules
  #   (name: {
  #     extraOptions = {
  #       myHomeManager.bundles.${name}.enable = lib.mkEnableOption "enable ${name} module bundle";
  #     };

  #     configExtension = config: (lib.mkIf cfg.bundles.${name}.enable config);
  #   })
  #   (myLib.filesIn ./bundles);

in {
  home-manager.users.${username}.imports =
    []
    ++ programs;
}

