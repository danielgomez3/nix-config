{ osConfig, pkgs,lib,...}:
let
  username = osConfig.myVars.username;
in
{
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
      
      };
    };
    
  };
}
