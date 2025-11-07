# heztner-vps/default.nix
# NOTE: This contains all common features I want only my server to have!
{
  config,
  pkgs,
  lib,
  inputs,
  host,
  ...
}: {
  myVars.username = "gamer"; # Specific username for this machine
  myVars.hostname = "living-room"; # Specific hostname for this machine
  networking.hostName = config.myVars.hostname;

  users.users.${config.myVars.username} = {
    description = "danielgomezcoder's living room gaming device";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAfIEr/ppknhpMfpGAMvMnm8bWQjB57KPy72qgUDz8u danielgomez3@server"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAfIEr/ppknhpMfpGAMvMnm8bWQjB57KPy72qgUDz8u danielgomez3@server"
  ];

  myNixOS = {
    core-system.enable = true;
    sops.enable = true;
  };

  home-manager.users.${config.myVars.username}.myHomeManager = {
    cli-apps.enable = true;
  };
}
