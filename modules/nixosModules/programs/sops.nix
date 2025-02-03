{ self, config, pkgs, lib, inputs,  name, ... }:
let 
  secretspath = builtins.toString inputs.mysecrets;
  username = config.myVars.username;
in
{
  environment.variables.GITHUB_TOKEN = config.sops.secrets.github_token.path;
  sops = {
    defaultSopsFile = "${secretspath}/secrets.yaml";
    defaultSopsFormat = "yaml";
    age = {
      keyFile = "/root/.config/sops/age/keys.txt";
      generateKey = true;
    };
    secrets = lib.mkMerge [
      {
        email = {};
        user_password = {
          neededForUsers = true;
        };
        "wireless.env" = {};
        "tailscale" = {};
        github_token = {
          owner = config.users.users.${username}.name;
          group = config.users.users.${username}.group;
        };
        "google_drive/id" = {};
        "google_drive/secret" = {};
        "syncthing/gui_password" = {}; 
      }
      (lib.mkIf config.myNixOS.syncthing.enable true {
        "syncthing/${name}/key_pem" = {
          owner = config.users.users.${username}.name;
          mode = "0700"; # Restrict read and write access to user only
        };
        "syncthing/${name}/cert_pem" = {
          owner = config.users.users.${username}.name;
          mode = "0700"; # Restrict read and write access to user only
        };
      })
    ];
  };

}
