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
  features =
    myLib.extendModules
    (name: {
      extraOptions = {
        myHomeManager.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
      };

      configExtension = config: (lib.mkIf cfg.${name}.enable config);
    })
    (myLib.filesIn ./features);

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
  home-manager = {
      imports =
        []
        ++ programs ++ features;
      backupFileExtension = "hm-backup";
      extraSpecialArgs = { inherit inputs; };
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
            android-tools adb-sync unzip android-tools ffmpeg mpv ventoy
            # Nix
            sops  just nixos-anywhere ssh-to-age colmena disko
          ];
        };
      myHomeManager = {
        kitty.enable = true; # Enable the kitty module
        zsh.enable = true; 
        bash.enable = false;
        vim.enable = true; 
        neovim.enable = true; 
        ssh.enable = true; 
        git.enable = true;
        starship.enable = true;
      };
    };
  };
}

