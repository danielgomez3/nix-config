{pkgs,...}:{

  services.mako = {
    enable = true;
    extraConfig =
    let
      play = sound:
        "mpv ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/${sound}.oga";
    in ''
      on-notify=exec ${play "message"}
    '';
  };

}
