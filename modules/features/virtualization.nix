{ config, lib, ...}:
let
  username = config.myVars.username;
in
  {
    # users.extraGroups.vboxusers.members = [ "daniel" ];
    users.users.${username}.extraGroups = [ "docker" ];

    virtualisation = {
      docker = {
        enable = true;
        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      }; 
      # virtualbox = {
      #   host = {
      #     enable = true;
      #     enableExtensionPack = true;
      #   };
      # };
    };
    
  }
