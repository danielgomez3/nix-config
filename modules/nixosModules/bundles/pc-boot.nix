{
  lib,
  config,
  ...
}: {
  myNixOS = {
    systemd-boot.enable = true;
    silent-boot.enable = true;
  };
}
