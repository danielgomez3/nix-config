{ config, pkgs, pkgsUnstable, lib, inputs,  ... }:
let 
#   cutefetch = import ./derivations/cutefetch.nix { inherit pkgs; };  # FIX attempting w/home-manager
  # myPythonEnv = pkgs.python3.withPackages (ps: with ps; [
  #   matplotlib
  # ]);
  username = config.myVars.username;
in
{
    #virtualisation.docker.enable = true;
    environment.variables.EDITOR = "${pkgsUnstable.helix}";
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      dataDir = "/var/lib/mysql";
      ensureUsers = [
        {
          name = "root";
          ensurePermissions = {
            "*.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    home-manager = { 
      useGlobalPkgs = true;
      users.${username} = {
        myHomeManager = {
          doom-emacs.enable = true;
          # helix.enable = true;
        };
        home.file.".ghc/ghci.conf".text = ''
          :set prompt "\ESC[34m\STX%s > \ESC[m\STX"
          :set stop :list
        '';
        home.packages = with pkgs; [
        # dev
        shellcheck exercism csvkit sshx fzf 
        pandoc-include poppler_utils graphviz librsvg 
        git-filter-repo 
        # texliveTeTeX
        texliveFull
        # Fun
        toilet fortune lolcat krabby cowsay figlet hollywood
        # coding
        cabal-install stack ghc
        sqlint
        nixpkgs-fmt
        # Hacking
        openvpn nmap gobuster nikto thc-hydra dirb steghide wpscan chisel
        python3 cargo
        ];

        programs = {

          direnv = {
            enable = true;
            enableZshIntegration = true;
            enableBashIntegration = true;
          };

          zoxide = {
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;
            enableFishIntegration = true;
          };

    

          fzf = { 
            enable = true;
            enableBashIntegration = false;
            enableZshIntegration = true;
          };
          pandoc = {
            enable = true;
            # templates = {
            #   "default.latex" = ../extra/pandoc-templates/eisvogel/eisvogel.latex;
            #   "default.markdown" = ../extra/pandoc-templates/eisvogel/eisvogel.latex;
            #   "default.pdf" = ../extra/pandoc-templates/eisvogel/eisvogel.latex;
            # };
          };
        };
      };
    };
}
