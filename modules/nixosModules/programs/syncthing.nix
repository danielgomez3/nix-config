{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  username = config.myVars.username;
  hostname = config.myVars.hostname;
in {
  # https://wiki.nixos.org/wiki/Syncthing#tips
  # Don't create default ~/Sync folder
  systemd.services = {
    syncthing.environment.STNODEFAULTFOLDER = "true";
  };
  services.syncthing = {
    enable = false;
    user = username;
    key = config.sops.secrets."syncthing/${hostname}/key_pem".path;
    cert = config.sops.secrets."syncthing/${hostname}/cert_pem".path;
    # dataDir = "/home/${username}/.config/data";
    # configDir = "/home/${username}/.config/syncthing";  # Folder for Syncthing's settings and keys
    overrideDevices = true; # overrides any devices added or deleted through the WebUI
    # overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    settings = {
      options.urAccepted = -1;
      devices = lib.mkMerge [
        (lib.mkIf config.myVars.isSyncthingServer {
          # Condition
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
        })

        (lib.mkIf config.myVars.isSyncthingClient {
          # Condition
          "server" = {
            id = "WDBCNRM-YJOKGOJ-FMABWTI-4UNDU2P-SKR3VP7-TEWBA3M-NKCT65Y-JHMVKQ3";
            autoAcceptFolders = true;
          };
        })
      ];

      folders = lib.mkMerge [
        (lib.mkIf config.myVars.isSyncthingServer {
          # Condition

          "Productivity" = {
            devices = ["desktop" "laptop" "phone"];
          };
          "Notes" = {
            devices = ["desktop" "laptop" "phone"];
          };
          "Downloads" = {
            devices = ["desktop" "laptop"];
          };
          "Misc" = {
            devices = ["desktop" "laptop"];
          };
          # "Projects" = {
          #   devices = [ "desktop" "laptop" ];
          # };
          "Shareable-pdfs" = {
            devices = ["desktop" "laptop" "phone"];
          };
        })

        (lib.mkIf config.myVars.isSyncthingClient {
          # Condition

          "Productivity" = {
            devices = ["server"];
          };
          # "Projects" = {
          #   devices = [ "server" ];
          # };
          "Notes" = {
            devices = ["server"];
          };
          "Misc" = {
            devices = ["server"];
          };
          "Downloads" = {
            devices = ["server"];
          };
          "Shareable-pdfs" = {
            devices = ["server"];
          };
        })

        {
          # Hopefully, control will go here as default regardless of condition

          "Downloads" = {
            path = "/home/${username}/Downloads";
            autoAccept = true;
            id = "Downloads";
          };
          "Productivity" = {
            path = "/home/${username}/Documents/productivity";
            autoAccept = true;
            id = "Productivity";
          };
          "Misc" = {
            path = "/home/${username}/Documents/misc";
            autoAccept = true;
            id = "Misc";
          };
          "Notes" = {
            path = "/home/${username}/Documents/notes";
            autoAccept = true;
            id = "Notes";
          };
          # "Projects" = {
          #   path = "/home/${username}/Documents/projects";
          #   autoAccept = true;
          #   id = "Projects";
          # };
          "Shareable-pdfs" = {
            path = "/home/${username}/Documents/shareable-pdfs";
            autoAccept = true;
            id = "Shareable-pdfs";
          };
        }
      ];
    };
  };
}
