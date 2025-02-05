{pkgs,...}:{
  
  myNixOS = {
    bundles.base-system.enable = true;
    netboot.enable = true;
    hydra.enable = true;
    borg-backup.enable = true;
    plex.enable = true;
    password-manager.enable = true;
  };

}
