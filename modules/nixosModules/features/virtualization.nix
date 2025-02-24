{ inputs, config, lib, pkgs, ...}:
let
  username = config.myVars.username;
in
  {

    ## NOTE: For Qemu
    systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];
    environment.systemPackages = with pkgs; [
      inputs.quickemu.packages.${system}.default
    ];

    ## NOTE: For Docker
    users.users.${username}.extraGroups = [ "docker" ];
    # virtualisation = {
    #   docker = {
    #     enable = true;
    #     rootless = {
    #       enable = true;
    #       setSocketVariable = true;
    #     };
    #   }; 

    ## NOTE: For Virtualbox
    users.extraGroups.vboxusers.members = [ "${config.myVars.username}" ];
    virtualisation.virtualbox.host.enable = true;
    virtualisation.virtualbox.host.enableExtensionPack = true;
    virtualisation.virtualbox.guest.enable = true;
    virtualisation.virtualbox.guest.dragAndDrop = true;

    
  }
