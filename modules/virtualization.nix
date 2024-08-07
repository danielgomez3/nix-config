{ config, username, ...}:
let
  cfg = config.services.virtualization;
in
  {
    options.services.virtualization = {
      enable = mkEnableOption "virtualization service";  
    };

    config = mkIf cfg.enable {

      # users.extraGroups.vboxusers.members = [ "daniel" ];
      users.users.${username}.extraGroups = [ "docker" ];

      virtualisation = {
        docker = {
          enable = true;
          rootles = {
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
