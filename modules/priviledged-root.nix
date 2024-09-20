{ username, pkgs, inputs, ... }:

{
  home-manager = { 
    extraSpecialArgs = { inherit inputs; };
    users.root = {
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
