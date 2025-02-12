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
      "my-disk" = {
        # suffix is to prevent disk name collisions
        type = "disk";
        # Set the following in flake.nix for each maschine:
        # device = <uuid>;
        content = {
          type = "gpt";
          partitions = {
            "boot" = {
              size = "1M";
              type = "EF02"; # for grub MBR
              priority = 1;
            };
            "ESP" = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "nofail" ];
              };
            };
            "root" = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                # format = "btrfs";
                # format = "bcachefs";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };


}
