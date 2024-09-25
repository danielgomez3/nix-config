{ pkgs, inputs, ... }:
{
  security.sudo.wheelNeedsPassword = false;
  users.users.deploy = {
  description = "Dedicated, isolated, and privileged user with admin privileges to deploy configs";
  isNormalUser = true;
  extraGroups = [ "wheel" ];
  shell = pkgs.bash;
  ignoreShellProgramCheck = true;
  };
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        # PermitRootLogin = "yes";        # Allow root login with password
      };
      knownHosts = {
        "desktop" = {
          hostNames = [ "desktop" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM9OcZ6CO1lDXOMQQawee8Fh6iydI8I+SXMdD9GESq8v";
        };
        "server" = {
          hostNames = [ "server" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHdnOQw9c23oUEIBdZFrKb/r4lHIKLZ9Dz11Un0erVsj";
        };
        "laptop" = {
          hostNames = [ "laptop" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQ4W1AIoMxiKJQXOwJlkJkwZ0pMOe/akO86duVI/NWG";
        };
        "deploy-server" = {
          hostNames = [ "server" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEA/kfm1TYsOaPnzbLYnWixnjHSYWgYcS82z/xQGKgwb";
        };
      };
    };
  };
  home-manager = { 
    extraSpecialArgs = { inherit inputs; };
    users.deploy = {
      home = {
        stateVersion = "24.05";
      };
      programs = {

        git = {
          enable = true;
          userName = "danielgomez3";
          userEmail = "danielgomez3@verizon.net";
          extraConfig = {
            credential.helper = "store";
          };
        };

        # FIXME: Add laptop. Also, this has to be changed with all.nix's version. Pretty stupid.
        ssh = {
          enable = true;
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
