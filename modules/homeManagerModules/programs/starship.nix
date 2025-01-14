{
pkgs,
config,
...
}: {

  starship = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = true;
  };

}

