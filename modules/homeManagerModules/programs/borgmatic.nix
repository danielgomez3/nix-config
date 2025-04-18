{osConfig, pkgs,lib,...}:
let
  username = osConfig.myVars.username;
in
{
  services.borgmatic = {
    enable = true;
    frequency = "*-*-* *:00/3:00";  # Run every 3 hours
    # frequency = "*-*-* *:0/30";
  };
  programs.borgmatic = {
    enable = true;
    backups.${username} = {
      location = {
        sourceDirectories = [ "/home/${username}/Documents"];
        repositories = [
          {
            "path" = "ssh://judi4lzd@judi4lzd.repo.borgbase.com/./repo";
            
            "label" = "server-backup";
          }
        ];
        extraConfig = {
          # remote_path = "borg1";
          # ssh_command = "ssh -i /home/${username}/.ssh/id_ed25519";
          borg_base_directory = "/home/${username}/Documents";
        };
      };
    };
    
  };
}

