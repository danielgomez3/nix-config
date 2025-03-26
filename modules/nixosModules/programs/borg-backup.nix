{ config, pkgs, lib, ... }:
let
  username = config.myVars.username;
in
{
  # FIXME: This requires initial ssh -i access. Make this pure..

  # NOTE:
  # to check on it, systemctl status borgbackup-job-borgbase.service
  # Also, root is the one that needs to give its key to manage borgbackup.
  services.borgbackup.jobs."borgbase" = {
    paths = [
      "/home/${username}/Documents"
    ];
    environment.BORG_RSH = "ssh -i /root/.ssh/id_ed25519";  # FIXME use pure sops nix path
    repo = "ssh://q4mtob1t@q4mtob1t.repo.borgbase.com/./repo";
    compression = "auto,zstd";
    startAt = "daily";
    persistentTimer = true;
    encryption = {
      mode = "none";
    };
  };


}
