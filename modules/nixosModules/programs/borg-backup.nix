{ config, pkgs, lib, ... }:
let
  username = config.myVars.username;
in
{
  # FIXME: This requires initial ssh -i access. Make this pure..
  services.borgbackup.jobs."borgbase" = {
    paths = [
      "/home/${username}/Documents"
    ];
      environment = {
        BORG_RSH = "ssh -i /root/.ssh/id_ed25519";  
        BORG_REPO_FILE = config.sops.secrets."borgbase/repo".path;
      };
    # repo = "ssh://q4mtob1t@q4mtob1t.repo.borgbase.com/./repo";
    repo = "@BORG_REPO@";  # Placeholder to be replaced at runtime
    compression = "auto,zstd";
    startAt = "daily";
    persistentTimer = true;
    encryption = {
      mode = "none";
    };
  };


}
