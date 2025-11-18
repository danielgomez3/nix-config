# user-config
{
  config,
  pkgs,
  lib,
  ...
}: {
  users = {
    # Define a user account. Don't forget to set a password with 'passwd'.
    mutableUsers = false; # Required for a password 'passwd' to be set via sops during system activation (over anything done imperatively)!
    users.root.initialHashedPassword = lib.mkForce null; # force it and override ISO installer module
    users.root.hashedPasswordFile = config.sops.secrets.user_password.path;
    users.${config.myVars.username} = {
      hashedPasswordFile = config.sops.secrets.user_password.path;
      isNormalUser = true;
      extraGroups = ["wheel"];
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true;
    };
  };
}
