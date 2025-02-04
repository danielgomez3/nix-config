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
    environment.BORG_RSH = "ssh -i /home/${username}/.ssh/id_ed25519";  # FIXME use pure sops nix path
    # repo = "ssh://q4mtob1t@q4mtob1t.repo.borgbase.com/./repo";
    repo = "ssh://q4mtob1t@q4mtob1t.repo.borgbase.com:repo";
    compression = "auto,zstd";
    startAt = "hourly";
    persistentTimer = true;
    encryption = {
      mode = "none";
    };
  };


}
