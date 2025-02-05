{pkgs,...}:{
  
  myNixOS = {
    bundles.base-system.enable = true;
    nix-netboot-serve.enable = true;
    hydra.enable = true;
    borg-backup.enable = true;
    plex.enable = true;
    password-manager.enable = true;
  };

}
