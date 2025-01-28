{ config, lib, pkgs, self, myHelper, ... }:
let
  username = config.myVars.username;
in
{
  # NOTE: Keys we want our normal user to have. We need to have root keys so we can access root and deploy.
  # User key is needed for personal use and ssh.
  # Root key is needed for colmena to rebuild 'apply'
  users.${username}.openssh.authorizedKeys.keys = myHelper.listOfPublicUserOrRootSshKeys;
  # NOTE: keys that we want root to have. Not necessary to have another root user's key.
  # TODO: Remember or explain why root even needs a user's key. I think it's for colmena or for Nixos-anywhere, I can't remember. It's most likely not even needed at all!
  users.root.openssh.authorizedKeys.keys = myHelper.listOfPublicUserSshKeys;
  services.openssh = {
    enable = true;
    # hostKeys = [
    #   {
    #     # XXX: No longer needed? Just generate a root user key and copy it over to /etc/ssh. Or what is done here: maybe you could set the path to /root/.ssh/id_ed25519 then copy that over.
    #     comment = "to be copied over to /etc/ssh/";
    #     path = "/etc/ssh/ssh_host_ed25519_key";
    #     # path = "/root/.ssh/id_ed25519";
    #     type = "ed25519";
    #   }
    # ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = true;
      # PermitRootLogin = "yes";        # Allow root login with password
    };
  };
}
