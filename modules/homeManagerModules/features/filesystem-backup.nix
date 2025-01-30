{ osConfig, pkgs,lib,...}:
let
  username = osConfig.myVars.username;
in
{
  services.borgmatic = {
    enable = true;
    frequency = "*-*-* *:00/3:00";  # Run every 3 hours
  };
  programs.borgmatic = {
    enable = true;
    backups.${username} = {
      location = {
        sourceDirectories = [ "/home/${username}/Documents"];
        repositories = [
          {
            "path" = "ssh://rc12y91q@rc12y91q.repo.borgbase.com/./repo";
            "label" = "server-backup";
          }
        ];
        extraConfig = {
          ssh_command = "ssh -i /home/${username}/.ssh/id_rsa";
          borg_base_directory = "/home/${username}/Documents";
        };
      };
    };
    
  };
}
