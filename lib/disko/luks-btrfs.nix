{config, ...}: let
  btrfsopt = [
    "compress=zstd"
    "noatime"
    "ssd"
    "space_cache=v2"
    "user_subvol_rm_allowed"
  ];
in {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        # device = "/dev/sda";
        device = "/dev/disk/by-id/scsi-0WDC_SDINFDO4-128G_WDC";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "1M";
              type = "ef02";
            };
            esp = {
              name = "esp";
              size = "500M";
              type = "ef00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "nixos";
                # passwordFile = "/tmp/pass";
                passwordFile = config.sops.secrets."luks_password".path; # or use keyFile for persistent storage
                extraFormatArgs = [
                ];
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "btrfs";
                  subvolumes = {
                    "@root" = {
                      mountpoint = "/";
                      mountOptions = btrfsopt;
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = btrfsopt;
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = btrfsopt;
                    };
                    "@data" = {
                      mountpoint = "/data";
                      mountOptions = btrfsopt;
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
