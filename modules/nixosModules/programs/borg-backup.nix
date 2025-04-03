{ config, pkgs, lib, ... }:
let
  username = config.myVars.username;
  hostname = config.myVars.hostname;
  borgExcludes = [
    "/nix"
    "/tmp"
    "/usr"
    "*.log"
    "*.db"
    "*.sqlite"
    "*.cache"
    "*/.cache/*"
    "*/node_modules/*"
    "*.tmp"
    "*.qcow2"
    "*.vdi"
    "*.iso"
  ];
in
{
  sops.secrets."private_ssh_keys/${hostname}" = {};
  # FIXME: This requires initial ssh -i access. Make this pure..

  # NOTE:
  # to check on it, systemctl status borgbackup-job-borgbase.service
  # Also, root is the one that needs to give its key to manage borgbackup.
  services.borgbackup.jobs."borgbase" = {
    paths = [
      "/home/${username}/Documents"
    ];
    exclude = borgExcludes;
    # FIXME use pure sops nix path:
    # BORG_RSH = "ssh -i ${config.age.secrets.borg-ssh-key.path}";
    # NOTE: Stable, working:
    # environment.BORG_RSH = "ssh -i /root/.ssh/id_ed25519";  
    environment.BORG = "ssh -i ${config.sops.secrets."private_ssh_keys/${hostname}_root".path}";
    repo = "ssh://q4mtob1t@q4mtob1t.repo.borgbase.com/./repo";
    compression = "auto,zstd";
    startAt = "daily";
    persistentTimer = true;
    encryption = {
      mode = "none";
    };
  };


}
