{config,...}:{

  services.plex = {
    enable = true;
    openFirewall = true;
    user = "${config.myVars.username}";
    # dataDir = "/home/${username}/plex";
  };
  
}
