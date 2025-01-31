
# server.nix
# NOTE: This contains all common features I want only my server to have!

{ config, pkgs, lib, inputs, host, name, ... }:

let 
  username = config.myVars.username;
in
{
  myVars.username = "REPLACEME";  # Specific username for this machine
  users.users.${username} = {
    description = "server";
  };
  myNixOS = {
    bundles.base-system.enable = true;
  };
  environment = {
    systemPackages = with pkgs; [
      kitty  # Make SSHing into this pretty.
      python3
    ];
  };


  home-manager = { 
    users = {
      ${username} = {
        myHomeManager = {
          cli-apps.enable = true;
        };      
      };
    };
  };



  # create a oneshot job to authenticate to Tailscale
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    # FIXME: using 'cat' for the password may be impure and may cause side effects when deploying using NixOs-Anywhere... Investigate!
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey $(cat ${config.sops.secrets.tailscale.path})
    '';
  };

}
