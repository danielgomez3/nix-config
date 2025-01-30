{config,pkgs,lib,...}:
let
  username = config.myVars.username;
in
{
  services.restic.backups = {
    gdrive = {
      user = "${username}";
      repository = "rclone:gdrive/${username}}";
      initialize = true;
      passwordFile = config.sops.secrets.user_password.path;
      paths = [
        "/home/${username}/Documents"
      ];
    };
  };
  home-manager.users.${username} = {
    home.packages = [ pkgs.rclone ];
      xdg.configFile."rclone/rclone.conf".text = ''
        [gdrive_mount]
        type = drive
        client_id = ${config.sops.secrets.gdrive_id}
        client_secret = ${config.sops.secrets.gdrive_secret}
      '';
  };
}
