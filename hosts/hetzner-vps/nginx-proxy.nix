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

    # HTTP/HTTPS virtual hosts
    virtualHosts."danielgomezcoder.org" = {
      locations."/" = {
        proxyPass = "http://10.100.0.2:80";
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
