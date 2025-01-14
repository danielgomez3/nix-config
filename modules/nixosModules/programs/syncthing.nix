{ ... }:
let
  username = config.myVars.username;
in
{
  services.syncthing = {
    enable = false;
    user = username;
    key = config.sops.secrets."syncthing/${name}/key_pem".path;
    cert = config.sops.secrets."syncthing/${name}/cert_pem".path;
    # dataDir = "/home/${username}/.config/data";
    # configDir = "/home/${username}/.config/syncthing";  # Folder for Syncthing's settings and keys
    overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    settings = {
      options.urAccepted = -1;
    };
    settings = {
      devices = {
        "desktop" = { 
          id = "WCI6FZO-QIWS4TH-IHIQIVM-O7QUE4O-DT2L4JM-BCCXKNM-FOSYHFB-BZSKNQW"; 
          autoAcceptFolders = true;
        };
        "phone" = { 
          id = "TSV6QDP-T6LBRW4-XKE6S2R-ETAYRSU-B2WHSCK-P3R62AX-3KZDTW4-GWSCZA2"; 
          autoAcceptFolders = true;
        };
        "server" = { 
          id = "WDBCNRM-YJOKGOJ-FMABWTI-4UNDU2P-SKR3VP7-TEWBA3M-NKCT65Y-JHMVKQ3"; 
          autoAcceptFolders = true;
        };
        "laptop" = { 
          id = "KENW57K-IHEFCFB-36STV55-62K3EMI-AX5HGSV-IKHWLX3-MULG6CZ-6DIEZAS"; 
          autoAcceptFolders = true;
        };
      };
      folders = {
        "Documents" = {         # Name of folder in Syncthing, also the folder ID
          path = "/home/${username}/Documents";    # Which folder to add to Syncthing
          devices = [ "desktop" "server" "laptop" ];      # Which devices to share the folder with
          autoAccept = true;
          id = "Documents";
        };
        "Productivity" = {
          path = "/home/${username}/Documents/productivity";
          devices = [ "desktop" "server" "laptop" "phone" ];
          autoAccept = true;
          id = "Productivity";
        };
        "Projects" = {
          path = "/home/${username}/Projects";
          devices = [ "desktop" "server" "laptop" ];
          autoAccept = true;
          id = "Projects";
        };
      };
    };
  };
}
