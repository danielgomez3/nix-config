{pkgs, lib, config, ...}:{

  security.pam.u2f = {
    enable = true;
    settings = {
      interactive = true;
      cue = true;
    };
    origin = "pam://yubi";
    # With this nix BIF wiserdry all new keys will have your username prepended:
    # username: <KeyHandle1>,<UserKey1>,<CoseType1>,<Options1>
    # username: <KeyHandle2>,<UserKey1>,<CoseType1>,<Options1>
    authfile = pkgs.writeText "u2f-mappings" (lib.concatStrings [
      "${config.myVars.username}"
      ":KwmuBGPZKMri0FD+47e8LylPHZTCUCJs80eXqHMGpNFVHpXAPdSA28KDwQA11jDLnPd35T3zZC/qzlR9r05c8Q==,mCJZMRISCeD9hAl3VX22MiGBk6USQ8ju54mxNOtQKqwqDy2IN0a/20XzWIVIO0OeRZ+i5KIEHueyBTORG69szQ==,es256,+presence"
    ]);
    # Now finally, enable it for sudo and login
    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
  };
}
