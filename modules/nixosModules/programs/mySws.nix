# https://nixos.wiki/wiki/Static_Web_Server

{config,pkgs,lib,...}:{

  # NOTE: By default, this will start SWS on [::]:8787
  services.static-web-server = {
    enable = true;
    root = "/home/${config.myVars.username}/my-http-server-root-dir";
  };

}
