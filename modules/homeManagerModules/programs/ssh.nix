{
  self,
  osConfig,
  pkgs,
  config,
  ...
}: {
  programs.ssh = {
    enable = true;
    # userKnownHostsFile = "${self.outPath}/hosts/${osConfig.myVars.hostname}/known_hosts";
    enableDefaultConfig = false;
    #   matchBlocks = {
    #     "server-hosts" = {
    #       host = "github.com gitlab.com";
    #       identitiesOnly = true;
    #     };
    #     "server" = {
    #       # hostname = "server.danielgomezcoder.org";
    #       hostname = "server";
    #       user = "danielgomez3"; # FIXME: use sops nix
    #     };
    #     "hetzner-vps" = {
    #       # hostname = "server.danielgomezcoder.org";
    #       hostname = "danielgomezcoder.org";
    #       user = "root"; # FIXME: use sops nix
    #     };
    #     "desktop" = {
    #       hostname = "desktop";
    #       user = "daniel"; # FIXME: use sops nix
    #     };
    #     "laptop" = {
    #       hostname = "laptop";
    #       user = "daniel"; # FIXME: use sops nix
    #     };
    # };
  };
}
