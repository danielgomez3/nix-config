{pkgs,config,...}:{

  virtualisation.docker.enable = true;
  users.users.${config.myVars.username}.extraGroups = [ "docker" ];
  # Rootless Docker
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

}
