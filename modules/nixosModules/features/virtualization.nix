{ inputs, config, lib, pkgs, ...}:
let
  username = config.myVars.username;
in
  {
    # users.extraGroups.vboxusers.members = [ "daniel" ];
    users.users.${username}.extraGroups = [ "docker" ];
    environment.systemPackages = with pkgs; [
      inputs.quickemu.packages.${system}.default
    ];

    # virtualisation = {
    #   docker = {
    #     enable = true;
    #     rootless = {
    #       enable = true;
    #       setSocketVariable = true;
    #     };
    #   }; 

    virtualisation.virtualbox.host.enable = true;
    virtualisation.virtualbox.host.enableExtensionPack = true;
    virtualisation.virtualbox.guest.enable = true;
    virtualisation.virtualbox.guest.dragAndDrop = true;

    
  }
