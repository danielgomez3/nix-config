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
          dig dmidecode 
          eza entr tldr bc tree zip
          pciutils usbutils 
          cifs-utils samba
          # cli apps
          yt-dlp beets spotdl protonvpn-cli_2
          tesseract ocrmypdf
          android-tools adb-sync unzip android-tools ffmpeg ventoy
          # Nix
          sops  just nixos-anywhere ssh-to-age colmena disko
        ];
      };
      imports =
        [
        ]
        ++ features ++ programs ++ bundles;
      # myHomeManager = {
      #   kitty.enable = true; # Enable the kitty module
      #   zsh.enable = true; 
      #   bash.enable = false;
      #   vim.enable = true; 
      #   neovim.enable = true; 
      #   ssh.enable = true; 
      #   git.enable = true;
      #   starship.enable = true;
      # };
    };
  };
}

