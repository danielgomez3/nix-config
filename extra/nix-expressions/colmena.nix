{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # ...
  };
  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      username = "daniel";
    in { 


    # Add this output, colmena will read its contents for remote deployment
      colmena = {
        meta = {
          nixpkgs = import nixpkgs { system = "x86_64-linux"; };

          # This parameter functions similarly to `specialArgs` in `nixosConfigurations.xxx`,
          # used for passing custom arguments to all submodules.
          specialArgs = {
            inherit nixpkgs;
          };
        };

        # Host name = "my-nixos"
        "my-nixos" = { name, nodes, ... }: {
          # Parameters related to remote deployment
          deployment.targetHost = "192.168.5.42"; # Remote host's IP address
          deployment.targetUser = "root";  # Remote host's username

          # This parameter functions similarly to `modules` in `nixosConfigurations.xxx`,
          # used for importing all submodules.
          imports = [
            ./configuration.nix
          ];
        };
      };
    };
}
