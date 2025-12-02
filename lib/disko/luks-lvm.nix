{config, ...}: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda";
        # device = "/dev/disk/by-id/scsi-0WDC_SDINFDO4-128G_WDC";
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
          # home = {
          #   size = "10M";
          #   content = {
          #     type = "filesystem";
          #     format = "ext4";
          #     mountpoint = "/home";
          #   };
          # };
          # raw = {
          #   size = "10M";
          # };
        };
      };
    };
  };
}
