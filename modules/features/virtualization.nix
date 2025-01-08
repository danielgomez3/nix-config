{ config, lib, ...}:
let
  username = config.myConfig.username;
in
  {
    options.services.virtualization = {
      enable = lib.mkEnableOption "virtualization service";  
    };


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
