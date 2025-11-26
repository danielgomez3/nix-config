# {config, ...}: {
#   disko.devices = {
#     disk = {
#       main = {
#         type = "disk";
#         device = "/dev/sdb";
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
#               label = "luks";
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
#                       swap.swapfile.size = "64G";
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
# disko-config.nix
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
