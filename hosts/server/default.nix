
# server.nix
# NOTE: This contains all common features I want only my server to have!

{ username, pkgs, inputs, ssh-keys, ... }:

{
  users.users.root.openssh.authorizedKeys.keys = ssh-keys;   
  users.users.${username} = {
    description = "server";
  };

  hardware.keyboard.zsa.enable = true;
  services = {
    coding = {
      enable = true;
    };
    all = {
      enable = true;
    };
    virtualization = {
      enable = true;
    };
    plex = {
      enable = true;
      openFirewall = true;
      user = "${username}";
      # dataDir = "/home/${username}/plex";
    };

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
        "deploy" = {
          hostNames = [ "root" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYrgc8D5QnHXMZT+npgXshrn4LSfDy8qlwHF53m/dvz";
        };
      };
    };

    syncthing = {
      guiAddress = "0.0.0.0:8384";
      settings.gui = {
        user = "${username}";
        # FIXME: This is bad. This is a unique password tho.
        password = "naruto88";  
      };
    };
  };

  home-manager = { 
    extraSpecialArgs = { inherit inputs; };
    users.${username} = {
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

            Host deploy
               HostName 192.168.12.149
               User root
                
          '';
          };
        };
      };
    };

  # home-manager = { 
  #   extraSpecialArgs = { inherit inputs; };
  #   users.${username} = {
  #     programs = with pkgs; {
  #       kitty = {
  #         font = {
  #           size = 11;
  #         };
  #       };
  #     };
  #   };
  #   packages = with pkgs; [
  #     hello
  #   ];

  # };

}
