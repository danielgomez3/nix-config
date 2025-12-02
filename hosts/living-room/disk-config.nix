# disko-config.nix
# NOTE:
# dual-boot windows and linux
# Configure your start value - decide how much space Windows needs (e.g., 100G for Windows + apps)
{...}: {
  disko.devices = {
    disk = {
      main = {
        device = "/dev/nvme0n1"; # Change this to your actual disk
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            # EFI System Partition (shared by both OSes)
            ESP = {
              type = "EF00";
              # size = "500M";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot"; # or "/efi"
                mountOptions = ["umask=0077"];
              };
            };

            # Linux root partition - starts after Windows space
            root = {
              # Reserve 100GB at the beginning for Windows
              start = "230G"; # Adjust this size based on your needs
              size = "100%"; # Take all remaining space for whatever you want (NixOS installation)
              content = {
                type = "filesystem";
                format = "bcachefs"; # or ext4, btrfs, etc.
                mountpoint = "/";
                mountOptions = ["compress=zstd"];
              };
            };
          };
        };
      };
    };
  };
}
