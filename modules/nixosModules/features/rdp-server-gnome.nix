{pkgs, ...}: {
  services.xrdp.enable = true;

  # Use the GNOME Wayland session
  services.xrdp.defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";

  # XRDP needs the GNOME remote desktop backend to function
  services.gnome.gnome-remote-desktop.enable = true;

  # Open the default RDP port (3389)
  services.xrdp.openFirewall = true;

  # Disable autologin to avoid session conflicts
  services.displayManager.autoLogin.enable = false;
  services.getty.autologinUser = null;

  # For any remote desktop server, it's crucial to disable automatic suspend features, which can activate if no local user is logged in and cause the machine to go offline.
  # Disable systemd targets for sleep and hibernation
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
}
