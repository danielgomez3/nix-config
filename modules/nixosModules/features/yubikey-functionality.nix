{
  pkgs,
  lib,
  config,
  ...
}: {
  security.pam.u2f = {
    enable = true;
    settings = {
      origin = "pam://yubi";
      interactive = true;
      cue = true;
      # With this nix BIF wiserdry all new keys will have your username prepended:
      # username: <KeyHandle1>,<UserKey1>,<CoseType1>,<Options1>
      # username: <KeyHandle2>,<UserKey1>,<CoseType1>,<Options1>
      authfile = pkgs.writeText "u2f-mappings" (lib.concatStrings [
        "${config.myVars.username}"
        #   ":${config.sops.secrets."yubikey/personal".path}"
        ":3EDoEBuJjlkzt4BoWXwgJmIyJNM4CqZ9jz9zugkwwvEyoN17sbs7SI6DHLOugn9R4wP45C7b/MPepQJbqc4wWw==,Bkt0pgykIRBt0ctjF9PFvecrUdAcMrTz2KBSVMLZYHp+SLmyYbN0ovsgaf0YrwPO8HzeSyn6n+ZxrKzlFK2o2Q==,es256,+presence"
        ":akNxejVD6tlpXiz7BDtTkOF/bgmRRvscrOC/YTkbi11WHFbCUvUfY4fDfgrbSJ6YKYLSBzbnTB2p/EKGm0aaPg==,hHV4nEdcB/p8AHNUi+4DdK2xBcqccFifIOHhz7ZuIwpAsXjiHH1MalFS6Y8c9Evp7XP6J0Es8WvqOKaIwAARuQ==,es256,+presence"
      ]);
      # authfile = config.sops.templates.u2fMappings.path;
    };
  };

  # Now finally, enable yubikey for sudo and login
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
}
