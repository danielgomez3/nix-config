{
pkgs,
config,
...
}: {

  programs.starship = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = true;
  };

}

