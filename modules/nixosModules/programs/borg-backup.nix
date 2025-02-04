{ config, pkgs, lib, ... }:
let
  username = config.myVars.username;
in
{
  services.borgbackup.jobs."home-${username}" = {
    paths = [
      "/home/${username}/Documents"
    ];
    encryption.mode = "none";
    environment.BORG_RSH = "ssh -i /home/${username}/.ssh/id_ed25519";
    repo = "ssh://s2iyaw6a@s2iyaw6a.repo.borgbase.com/./repo";
    compression = "auto,zstd";
    startAt = "daily";
  };


}
