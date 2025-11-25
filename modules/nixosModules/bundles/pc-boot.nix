{
  lib,
  config,
  ...
}: {
  myNixOS = {
    systemd-boot.enable = true;
    slient-boot.enable = true;
  };
}
