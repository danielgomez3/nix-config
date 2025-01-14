{pkgs,lib,config,name,...}:
let
  username = config.myVars.username;
in
{
  home-manager.users.${username}.programs.swaylock.enable = true;

  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowHybridSleep=yes
    AllowSuspendThenHibernate=yes
  '';

  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "swaylock";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "swaylock";
          }
          {
            timeout = 390;
            on-timeout = "systemctl suspend";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };

}
