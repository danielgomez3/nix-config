{
  pkgs,
  lib,
  ...
}: {
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    enableBashIntegration = true;
  };
}
