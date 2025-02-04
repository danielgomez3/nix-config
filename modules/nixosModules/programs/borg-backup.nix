{ config, pkgs, lib, ... }:
let
  username = config.myVars.username;
in
{
  services.borgbackup.jobs."home-${username}" = {
    paths = [
      "/home/${username}/Documents"
    ];
    environment.BORG_RSH = "ssh -i /home/${username}/.ssh/id_ed25519";
    repo = "ssh://q4mtob1t@q4mtob1t.repo.borgbase.com/./repo";
    compression = "auto,zstd";
    startAt = "hourly";
    persistentTimer = true;
    encryption = {
      mode = "none";
    };
  };


}
