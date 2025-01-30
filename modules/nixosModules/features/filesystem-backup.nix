{config,pkgs,lib,...}:
let
  username = config.myVars.username;
in
{
  services.borgbackup.jobs.${username} = {
    paths = "/home/${username}";
    encryption.mode = "none";
    environment.BORG_RSH = "ssh -i /home/${username}/.ssh/id_ed25519";
    repo = "ssh://i7y02z7l@i7y02z7l.repo.borgbase.com/./repo";
    compression = "auto,zstd";
    startAt = "daily";
  };
}
