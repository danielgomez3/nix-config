{config,pkgs,lib,...}:
let
  username = config.myVars.username;
in
{
  environment.systemPackages = with pkgs; [
    restic
  ];
  
  users.users.restic = {
    isNormalUser = true;
  };

  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = "restic";
    group = "users";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };
    services.restic = {
    backups = {
      remote = {
        paths = [
          "/home/${username}/Development"
          "/home/${username}/Documents"
          "/home/${username}/Sync"
          "/home/${username}/Photos"
        ];
        environmentFile = config.age.secrets.restic-env.path;
        passwordFile = config.age.secrets.restic-pw.path;
        repository = "s3:https://b0850d27a4d43d7d0f8d36ebc6a1bfab.r2.cloudflarestorage.com/restic-9000-b147";
        initialize = true;
        timerConfig.OnCalendar = "*-*-* *:00:00";
        timerConfig.RandomizedDelaySec = "5m";
        extraBackupArgs = [
          "--exclude=\".direnv\""
          "--exclude=\".terraform\""
          "--exclude=\"node_modules/*\""
        ];
      };
    };
  };

}
