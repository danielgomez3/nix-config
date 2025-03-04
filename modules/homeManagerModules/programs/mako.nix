{pkgs,...}:{
    home.packages = with pkgs; [
       libnotify pulseaudioFull
    ];
    services.mako = {
      enable = true;
      layer = "overlay";
      width = 500;
      height = 160;
      defaultTimeout = 10000;
      maxVisible = 10;
      iconPath = "${pkgs.breeze-icons}/share/icons/breeze-dark";
      maxIconSize = 24;
      extraConfig = let
        play = sound:
          "${pkgs.pulseaudio}/bin/paplay ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/${sound}.oga";
      in ''
        on-notify=exec ${play "complete"}
      '';
    };

}
