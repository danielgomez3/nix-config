# web-server.nix
{...}: {
  services.nginx = {
    enable = true;

    # Only listen on WireGuard interface for security
    virtualHosts."local.danielgomezcoder.org" = {
      listen = [
        {
          addr = "10.100.0.2";
          port = 80;
        }
      ];
      root = "/var/www/html"; # or wherever you want to serve files from

      locations."/" = {
        index = "index.html index.htm";
      };
    };
  };

  # Open port 80 only on WireGuard interface
  networking.firewall.interfaces.wg0.allowedTCPPorts = [80];
}
