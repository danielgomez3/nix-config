{
  pkgs,
  system,
  inputs,
  config,
  lib,
  myHelper,
  self,
  pkgsUnstable,
  ...
}: let
  cfg = config.home-manager.users.${username}.myHomeManager;
  username = config.myVars.username;


  # Taking all modules in ./features and adding enables to them
  features =
    myHelper.extendModules
    (name: {
      extraOptions = {
        myHomeManager.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
      };

      configExtension = config: (lib.mkIf cfg.${name}.enable config);
    })
    (myHelper.filesIn ./features);

  programs =
    myHelper.extendModules
    (name: {
      extraOptions = {
        myHomeManager.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
      };

      configExtension = config: (lib.mkIf cfg.${name}.enable config);
    })
    (myHelper.filesIn ./programs);

  # Taking all module bundles in ./bundles and adding bundle.enables to them
  bundles =
    myHelper.extendModules
    (name: {
      extraOptions = {
        myHomeManager.bundles.${name}.enable = lib.mkEnableOption "enable ${name} module bundle";
      };

      configExtension = config: (lib.mkIf cfg.bundles.${name}.enable config);
    })
    (myHelper.filesIn ./bundles);

in {
  home-manager = {
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit inputs self pkgsUnstable; };
    users.${username} = {
      home = {
        stateVersion = "24.05";
        packages = with pkgs; [
          dig unzip ffmpeg 
	  #dmidecode   # FIXME: nix-darwin doesn't like this
          eza entr tldr bc tree zip
          pciutils usbutils 
          #cifs-utils  # FIXME: same
 	  samba
          # cli apps
          yt-dlp beets spotdl 
	  #protonvpn-cli_2  # FIXME: same
          tesseract ocrmypdf
          #android-tools adb-sync android-tools ventoy  # FIXME: same, but allowUnfree for darwin
          # Nix
          sops  just nixos-anywhere ssh-to-age colmena 
	  #disko  # FIXME: allow unfree for darwin
        ];
      };
      imports =
        [
          # (inputs.home-manager-unstable + "/modules/programs/pay-respects.nix")  # This wouldn't work, maybe with a simpler package it will. It's unstable for a reason
        ]
        ++ features ++ programs ++ bundles;
    };
  };
}

