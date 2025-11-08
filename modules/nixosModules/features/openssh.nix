# openssh.nix
# TODO: this might be broken, this should only allow the 'server' home server ssh access to any other device, not the other way around..
{
  config,
  lib,
  pkgs,
  self,
  # myHelper,
  ...
}: let
  # username = config.myVars.username;
  # regexUserOrRootKey = ".*key\\.pub$"; # FIXME broken. Does root too
  # regexUserKey = ".*/key\\.pub$";
in {
  users.users.${config.myVars.username} = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAfIEr/ppknhpMfpGAMvMnm8bWQjB57KPy72qgUDz8u danielgomez3@server"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAfIEr/ppknhpMfpGAMvMnm8bWQjB57KPy72qgUDz8u danielgomez3@server"
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      # X11Forwarding = true;
      # PermitRootLogin = "yes";        # Allow root login with password
    };
  };

  # # NOTE: Keys we want our normal user to have. We need to have root keys so we can access root and deploy.
  # # User key is needed for personal use and ssh.
  # # Root key is needed for colmena to rebuild 'apply'
  # users.users.${username}.openssh.authorizedKeys.keys =
  #   myHelper.readContentsOfFiles
  #   (myHelper.recSearchFileExtension regexUserKey "${self.outPath}/hosts");
  # # FIXME: Give root only other root keys.
  # users.users.root.openssh.authorizedKeys.keys =
  #   myHelper.readContentsOfFiles
  #   (myHelper.recSearchFileExtension regexUserOrRootKey "${self.outPath}/hosts");
}
