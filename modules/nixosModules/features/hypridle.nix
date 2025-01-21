{pkgs,lib,config,name,...}:
let
  username = config.myVars.username;
in
{


  home-manager.users.${username} = {
    services = {
      hypridle = {
        enable = false;
        settings = {
          general = {
            after_sleep_cmd = "hyprctl dispatch dpms on";
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
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
    };
  };

}
