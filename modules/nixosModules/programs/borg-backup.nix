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
