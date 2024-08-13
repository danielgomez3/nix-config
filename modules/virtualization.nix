{ config, lib, username, ...}:
let
  cfg = config.services.virtualization;
in
  {
    options.services.virtualization = {
      enable = lib.mkEnableOption "virtualization service";  
    };

    config = lib.mkIf cfg.enable {

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
    
    };
  }
