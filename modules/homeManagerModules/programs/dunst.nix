{ config, pkgs, ... }:
let
  # playNotificationSound = pkgs.writeShellScript "play-notification-sound" ''
  #     ${pkgs.pulseaudio}/bin/paplay --volume 30000 ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/complete.oga
  # '';
  playNotificationSound = sound:
    "${pkgs.pulseaudio}/bin/paplay ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/${sound}.oga";

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

      urgency_critical = {
        msg_urgency = "critical";
        script = "${playNotificationSound "message"}";
      };

      urgency_normal = {
        script = "${playNotificationSound "complete"}";
      };

      play_sound = {
        summary = "*";
        script = "${playNotificationSound "message"}";
      };
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
      size = "8x8";
    };
  };
}

