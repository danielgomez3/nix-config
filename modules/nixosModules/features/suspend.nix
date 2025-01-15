{pkgs,lib,config,name,...}:
let
  username = config.myVars.username;
in
{

  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowHybridSleep=yes
    AllowSuspendThenHibernate=yes
  '';

  home-manager.users.${username} = {
    programs.swaylock.enable = true;
    services = {
      hypridle = {
        enable = true;
        settings = {
          general = {
            after_sleep_cmd = "${pkgs.hyprctl} dispatch dpms on";
            ignore_dbus_inhibit = false;
            lock_cmd = "swaylock";
          };
          listener = [
            {
              timeout = 20;
              on-timeout = "swaylock";
            }
            {
              timeout = 30;
              on-timeout = "systemctl suspend";
              on-resume = "${pkgs.hyprctl} dispatch dpms on";
            }
          ];
        };
      };
    };
  };

}
