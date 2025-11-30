# {config, ...}: {
#   disko.devices = {
#     disk = {
#       main = {
#         # imageSize = "40G";
#         type = "disk";
#         device = "/dev/disk/by-id/scsi-0WDC_SDINFDO4-128G_WDC";
#         content = {
#           type = "gpt";
#           partitions = {
#             ESP = {
#               label = "boot";
#               name = "ESP";
#               size = "512M";
#               type = "EF00";
#               content = {
#                 type = "filesystem";
#                 format = "vfat";
#                 mountpoint = "/boot";
#                 mountOptions = [
#                   "defaults"
#                   "umask=0077"
#                 ];
#               };
#             };
#             luks = {
#               size = "100%";
#               content = {
#                 type = "luks";
#                 name = "cryptroot";
#                 # Remove FIDO2 settings and use password instead
#                 passwordFile = config.sops.secrets."luks_password".path; # or use keyFile for persistent storage
#                 # passwordFile = "/tmp/secret.key"; # or use keyFile for persistent storage
#                 # Alternative: remove passwordFile and you'll be prompted during build
#                 extraOpenArgs = [
#                   "--allow-discards"
#                   "--perf-no_read_workqueue"
#                   "--perf-no_write_workqueue"
#                 ];
#                 content = {
#                   type = "btrfs";
#                   extraArgs = ["-L" "nixos" "-f"];
#                   subvolumes = {
#                     "/root" = {
#                       mountpoint = "/";
#                       mountOptions = ["subvol=root" "compress=zstd" "noatime"];
#                     };
#                     "/home" = {
#                       mountpoint = "/home";
#                       mountOptions = ["subvol=home" "compress=zstd" "noatime"];
#                     };
#                     "/nix" = {
#                       mountpoint = "/nix";
#                       mountOptions = ["subvol=nix" "compress=zstd" "noatime"];
#                     };
#                     "/persist" = {
#                       mountpoint = "/persist";
#                       mountOptions = ["subvol=persist" "compress=zstd" "noatime"];
#                     };
#                     "/log" = {
#                       mountpoint = "/var/log";
#                       mountOptions = ["subvol=log" "compress=zstd" "noatime"];
#                     };
#                     "/swap" = {
#                       mountpoint = "/swap";
#                       swap.swapfile.size = "8G";
#                     };
#                   };
#                 };
#               };
#             };
#           };
#         };
#       };
#     };
#   };
#   fileSystems."/persist".neededForBoot = true;
#   fileSystems."/var/log".neededForBoot = true;
# }
# NOTE: this worked, couldn't log in!
# {config, ...}: let
#   btrfsopt = [
#     "compress=zstd"
#     "noatime"
#     "ssd"
#     "space_cache=v2"
#     "user_subvol_rm_allowed"
#   ];
# in {
#   disko.devices = {
#     disk = {
#       main = {
#         type = "disk";
#         # device = "/dev/sda";
#         device = "/dev/disk/by-id/scsi-0WDC_SDINFDO4-128G_WDC";
#         content = {
#           type = "gpt";
#           partitions = {
#             boot = {
#               name = "boot";
#               size = "1M";
#               type = "ef02";
#             };
#             esp = {
#               name = "esp";
#               size = "500M";
#               type = "ef00";
#               content = {
#                 type = "filesystem";
#                 format = "vfat";
#                 mountpoint = "/boot";
#               };
#             };
#             luks = {
#               size = "100%";
#               content = {
#                 type = "luks";
#                 name = "nixos";
#                 # passwordFile = "/tmp/pass";
#                 passwordFile = config.sops.secrets."luks_password".path; # or use keyFile for persistent storage
#                 extraFormatArgs = [
#                 ];
#                 settings = {
#                   allowDiscards = true;
#                 };
#                 content = {
#                   type = "btrfs";
#                   subvolumes = {
#                     "@root" = {
#                       mountpoint = "/";
#                       mountOptions = btrfsopt;
#                     };
#                     "@home" = {
#                       mountpoint = "/home";
#                       mountOptions = btrfsopt;
#                     };
#                     "@nix" = {
#                       mountpoint = "/nix";
#                       mountOptions = btrfsopt;
#                     };
#                     "@data" = {
#                       mountpoint = "/data";
#                       mountOptions = btrfsopt;
#                     };
#                   };
#                 };
#               };
#             };
#           };
#         };
#       };
#     };
#   };
# }
{config, ...}: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        # device = "/dev/vdb";
        device = "/dev/disk/by-id/scsi-0WDC_SDINFDO4-128G_WDC";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                extraOpenArgs = [];
                passwordFile = config.sops.secrets."luks_password".path; # or use keyFile for persistent storage

                settings = {
                  # if you want to use the key for interactive login be sure there is no trailing newline
                  # for example use `echo -n "password" > /tmp/secret.key`
                  # keyFile = "/tmp/secret.key";
                  allowDiscards = true;
                };
                # additionalKeyFiles = ["/tmp/additionalSecret.key"];
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
              ];
            };
          };
          home = {
            size = "10M";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home";
            };
          };
          raw = {
            size = "10M";
          };
        };
      };
    };
  };
}
