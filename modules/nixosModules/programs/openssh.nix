{ config, lib, pkgs, self, ... }:
{
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
