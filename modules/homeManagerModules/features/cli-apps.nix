{
  pkgs,
  lib,
  ...
}: {
  myHomeManager = {
    zsh.enable = false;
    nushell.enable = true;
    starship.enable = true;
    ssh.enable = true;
    git.enable = true;
    neovim.enable = true;
    zellij.enable = true;
  };
}
