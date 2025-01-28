{
  # disko.devices = {
  #   disk = {
  #     my-disk = {
  #       device = "/dev/nvme0n1";
  #       type = "disk";
  #       content = {
  #         type = "gpt";
  #         partitions = {
  #           ESP = {
  #             type = "EF00";
  #             size = "500M";
  #             content = {
  #               type = "filesystem";
  #               format = "vfat";
  #               mountpoint = "/boot";
  #             };
  #           };
  #           root = {
  #             size = "100%";
  #             content = {
  #               type = "filesystem";
  #               format = "ext4";
  #               mountpoint = "/";
  #             };
  #           };
  #         };
  #       };
  #     };
  #   };
  # };

  disko.devices = {
    disk = {
      my-disk = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M"; # EFI System Partition for both NixOS and Windows
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "fmask=0077" "dmask=0077" ];
              };
            };
            nixos-root = {
              size = "50%"; # Adjust size as needed for NixOS
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
            windows = {
              size = "50%"; # Reserved space for Windows
              content = {
                type = "filesystem"; # Leave this partition unformatted for Windows
                format = "ntfs";
                mountpoint = null; # Windows will use this; NixOS won't mount it
              };
            };
          };
        };
      };
    };
  };

}
