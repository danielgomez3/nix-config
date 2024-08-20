{ username, pkgs, inputs, ssh-keys, ... }:

{
  users.users.root.openssh.authorizedKeys.keys = ssh-keys;   

  home-manager = { 
    extraSpecialArgs = { inherit inputs; };
    users.root = {
      home = {
        stateVersion = "24.05";
      };
      programs = {
        # FIXME: Add laptop. Also, this has to be changed with all.nix's version. Pretty stupid.
        ssh = {
          extraConfig = ''
            Host server
               HostName 192.168.12.149 
               User danielgomez3

            Host desktop
               HostName 192.168.12.182
               User daniel
          '';
          };
        };
      };
    };
}
