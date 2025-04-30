{ self, config, pkgs, lib, inputs, ... }:
let 
  secretspath = builtins.toString inputs.mysecrets;
  username = config.myVars.username;
  hostname = config.myVars.hostname;

in
{
  environment.variables.GITHUB_TOKEN = config.sops.secrets.github_token.path;
  sops = {
    defaultSopsFile = "${secretspath}/secrets.yaml";
    defaultSopsFormat = "yaml";
    age = {
      keyFile = "/root/.config/sops/age/keys.txt";
      # generateKey = true;
    };
    secrets = lib.mkMerge [
      {
        email = {};
        user_password = {
          neededForUsers = true;
        };
        "yubikey/personal" = {};
        "username/server" = {};
        "username/default" = {};
        "wireless.env" = {};
        "tailscale" = {};
        "borgbase/repo" = {};
        github_token = {
          owner = config.users.users.${username}.name;
          group = config.users.users.${username}.group;
        };
        "google_drive/id" = {};
        "google_drive/secret" = {};
        "syncthing/gui_password" = {}; 
      }
      # TODO: maybe put this in only syncthing.nix?
      (lib.mkIf config.myNixOS.syncthing.enable {
        "syncthing/${hostname}/key_pem" = {
          owner = config.users.users.${username}.name;
          mode = "0700"; # Restrict read and write access to user only
        };
        "syncthing/${hostname}/cert_pem" = {
          owner = config.users.users.${username}.name;
          mode = "0700"; # Restrict read and write access to user only
        };
      })
    ];
  };

}
