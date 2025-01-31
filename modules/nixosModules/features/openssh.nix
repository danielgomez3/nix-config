{ config, lib, pkgs, self, myHelper, ... }:
let
  username = config.myVars.username;
  regexUserOrRootKey = ".*key\\.pub$";  # FIXME broken. Does root too
  regexUserKey = ".*/key\\.pub$";
in
{
  # NOTE: Keys we want our normal user to have. We need to have root keys so we can access root and deploy.
  # User key is needed for personal use and ssh.
  # Root key is needed for colmena to rebuild 'apply'
  users.users.${username}.openssh.authorizedKeys.keys =
    myHelper.readContentsOfFiles
    (myHelper.recSearchFileExtension regexUserOrRootKey "${self.outPath}/hosts");
  # NOTE: keys that we want root to have. Not necessary to have another root user's key.
  # Root needs a user's keys because ...?
  users.users.root.openssh.authorizedKeys.keys =
    myHelper.readContentsOfFiles
    (myHelper.recSearchFileExtension regexUserKey "${self.outPath}/hosts");
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = true;
      # PermitRootLogin = "yes";        # Allow root login with password
    };
  };
}
