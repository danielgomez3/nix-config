{pkgs,...}:{
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
          "mpv ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/${sound}.oga";
      in ''
        on-notify=exec ${play "message"}
        [app-name=yubikey-touch-detector]
        on-notify=exec ${play "service-login"}
        [app-name=command_complete summary~="✘.*"]
        on-notify=exec ${play "dialog-warning"}
        [app-name=command_complete summary~="✓.*"]
        on-notify=exec ${play "bell"}
        [category=osd]
        on-notify=none
        [mode=do-not-disturb]
        invisible=1
        [mode=do-not-disturb summary="Do not disturb: on"]
        invisible=0
        [mode=concentrate]
        invisible=1
        [mode=concentrate urgency=critical]
        invisible=0
        [mode=concentrate summary="Concentrate mode: on"]
        invisible=0
      '';
    };

}
