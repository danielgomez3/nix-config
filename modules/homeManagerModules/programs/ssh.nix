{
pkgs,
config,
...
}: {

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "server" = {
        # hostname = "server.danielgomezcoder.org";
        hostname = "server";
        user = "danielgomez3";  # FIXME: use sops nix
      };
      "desktop" = {
        hostname = "desktop";
        user = "daniel";  # FIXME: use sops nix
      };
      "laptop" = {
        hostname = "laptop";
        user = "daniel";  # FIXME: use sops nix
      };
      # "laptop" = {
      #   host = "deploy";
      #   hostname = "danielgomezcoder-l.duckdns.org";
      #   user = "root";  # FIXME: use sops nix
      # };
    };
  };

}

