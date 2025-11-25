{
  pkgs,
  lib,
  ...
}: {
  # Boot
  boot = {
    # Plymouth
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth.enable = true; # Visually appealing splash screen
    kernelParams = ["quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" "boot.shell_on_fail"];

    # Boot Loader
  };
}
