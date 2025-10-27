# hosts/hetzner-vps/nginx-proxy.nix
{
  config,
  pkgs,
  ...
}: let
  ports = config.myVars.ports;
in {
  services.nginx = {
    enable = true;

    ## These are implicit defaults, but good to be explicit:
    # listen = [
    #   {
    #     addr = "0.0.0.0";
    #     port = 80;
    #   }
    #   # If you have SSL configured, add port 443 here too
    # ];

    # HTTP/HTTPS virtual hosts
    virtualHosts."danielgomezcoder.org" = {
      locations."/" = {
        # normally default is 80 for http, or 443 for https. We are forwarding it to port 8787, because.. we wanted to.
        # user visits danielgomezcoder.org. VPS Nginx listens on 80/443 (default for everyone). The, we forward it to this IP address at 8787 (our wireguard tunnel)
        proxyPass = "http://10.100.0.2:8787";
        proxyWebsockets = true;
      };
    };

    # TCP/UDP proxy for Minecraft
    streamConfig = ''
      upstream minecraft_backend {
          server 10.100.0.2:${toString ports.mc};
      }

      server {
          listen ${toString ports.mc};
          proxy_pass minecraft_backend;
          proxy_timeout 1h;
      }
    '';
  };
}
