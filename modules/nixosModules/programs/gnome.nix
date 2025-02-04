{config,pkgs,...}:
let
  username = config.myVars.username;
in
{
  
  environment.systemPackages = [
    pkgs.adwaita-icon-theme
    pkgs.gnomeExtensions.appindicator  # For systray icons
    pkgs.dconf-editor
  ];

  services.udev.packages = [ pkgs.gnome-settings-daemon ];  # For systray icons

  services.dbus.packages = with pkgs; [ gnome2.GConf ];  # Support for older packages


  hardware.sensor.iio.enable = true;  # Automatic screen rotation

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # programs.dconf = {
  #   enable = true;
  #   settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  # };
}
