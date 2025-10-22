{config, ...}: {
  # Access via http://lan_ip:32400/web
  services.plex = {
    enable = true;
    openFirewall = true;
    user = "${config.myVars.username}";
    # dataDir = "/home/${username}/plex";
  };
}
