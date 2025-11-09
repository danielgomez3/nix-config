{
  pkgs,
  lib,
  ...
}: {
  myHomeManager = {
    zsh.enable = true;
    nushell.enable = false;
    starship.enable = true;
    ssh.enable = true;
    git.enable = true;
    neovim.enable = true;
    zellij.enable = true;
    rclone.enable = true;
    btop.enable = true;
  };
}
