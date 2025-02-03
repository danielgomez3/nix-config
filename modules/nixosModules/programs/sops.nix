{ self, config, pkgs, lib, inputs,  name, ... }:
let 
  secretspath = builtins.toString inputs.mysecrets;
  username = config.myVars.username;
in
{
  environment.variables.GITHUB_TOKEN = config.sops.secrets.github_token.path;
  sops = {
    # HACK: sops nix Cannot read ssh key '/etc/ssh/ssh_host_rsa_key':
    # gnupg.sshKeyPaths = [];
    defaultSopsFile = "${secretspath}/secrets.yaml";
    defaultSopsFormat = "yaml";
    age = {
      keyFile = "/root/.config/sops/age/keys.txt";
      generateKey = true;
    };
    secrets = {
      email = {};
      user_password = {
        # Decrypt 'user-password' to /run/secrets-for-users/ so it can be used to create the user and assign their password without having to run 'passwd <user>' imperatively:
        neededForUsers = true;
      };
      "wireless.env" = {};
      # "wifi_networks/home_ssid" = {};
      # "wifi_networks/home_psk" = {};
      "tailscale" = {};
      github_token = {
        owner = config.users.users.${username}.name;
        group = config.users.users.${username}.group;
      };
      "google_drive/id" = {};
      "google_drive/secret" = {};
      # "private_ssh_keys/common" = {  # This way, it could be server, desktop, whatever!
      #   # Automatically generate this private key at this location if it's there or not:
      #   path = "/home/${username}/.ssh/id_ed25519";
      #   # mode = "600";
      #   owner = config.users.users.${username}.name;
      # };
      # "private_ssh_keys/root" = {  
      #   path = "/root/.ssh/id_ed25519";
      #   owner = config.users.users.root.name;
      # };
      # example_key = { };
      # "myservice/my_subdir/my_secret" = {
      #   owner = config.users.users.${username}.name; # Make the token accessible to this user
      #   group = config.users.users.${username}.group; # Make the token accessible to this group
      # };    
    }
    // (lib.mkIf config.myNixOS.syncthing.enable {
      "syncthing/gui_password" = {}; 
      "syncthing/${name}/key_pem" = {
        owner = config.users.users.${username}.name;
        # group = config.users.users.${username}.group;
        mode = "0700"; # Restrict read and write access to user only
      };
      "syncthing/${name}/cert_pem" = {
        owner = config.users.users.${username}.name;
        # group = config.users.users.${username}.group;
        mode = "0700"; # Restrict read and write access to user only
      };
    });
  };
}
