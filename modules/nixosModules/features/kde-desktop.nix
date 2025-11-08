{...}: {
  services.xserver.enable = true;
  # services.displayManager.sddm = {
  #   enable = true;
  #   wayland.enable = true;
  #   settings = {
  #     General = {
  #       # Scale SDDM UI by 2x for TV
  #       GreeterEnvironment = "QT_SCREEN_SCALE_FACTORS=2";
  #     };
  #   };
  # };
  services.desktopManager.plasma6.enable = true;
}
