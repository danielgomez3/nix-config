{ config, pkgs, ... }:
let
  playNotificationSound = pkgs.writeShellScript "play-notification-sound" ''
    ${pkgs.pulseaudio}/bin/mpv ${pkgs.yaru-theme}/share/sounds/Yaru/stereo/message.oga
  '';
in
{
  home.packages = with pkgs; [
     libnotify
  ];
  services.dunst = {
    enable = true;
    settings = {
      global = rec {
        origin = "bottom-right";
        line_height = 5;
        width = 300;
        height = 500;
        progress_bar = true;
        markup = "full";
        format = "<i>%a</i>\\n<b>%s</b>\\n%b";
      };

      base16_low = {
        msg_urgency = "low";
      };

      base16_normal = {
        msg_urgency = "normal";
      };

      base16_critical = {
        msg_urgency = "critical";
      };

      play_sound = {
        summary = "*";
        script = "${playNotificationSound}";
      };
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
      size = "32x32";
    };
  };
}

