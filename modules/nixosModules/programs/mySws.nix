{config,pkgs,lib,...}:{

  services.static-web-server = {
    enable = true;
    root = "/home/${config.myVars.username}/my-http-server-root-dir";
  };

}
