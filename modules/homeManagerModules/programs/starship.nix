{
  pkgs,
  config,
  ...
}: {
  programs.starship = {
    enable = false;
    enableBashIntegration = false;
    enableZshIntegration = true;
  };
}
