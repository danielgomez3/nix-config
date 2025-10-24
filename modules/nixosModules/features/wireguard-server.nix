# wireguard-server.nix
# NOTE: this is taylored specifically a VPS instance, it's not dynamic at all.
{
  pkgs,
  config,
  inputs,
  ...
}: let
  username = config.myVars.username;
  hostname = config.myVars.hostname;
  ports = config.myVars.ports;
in {
  # Keep your existing WireGuard server config
  networking.wireguard.interfaces.wg0 = {
    ips = ["10.100.0.1/24"];
    listenPort = 51820;
    privateKeyFile = config.sops.secrets."wireguard-private-key-file/${hostname}".path;
    peers = [
      {
        publicKey = "XAek67dqDTUuk94381DYI2bCHEdbC9l26tNH58FIUD8=";
        allowedIPs = ["10.100.0.2/32"];
        persistentKeepalive = 25;
      }
    ];
  };

  # ADD this for port forwarding
  networking.nat = {
    enable = true;
    externalInterface = "eth0";
    internalInterfaces = ["wg0"];
    forwardPorts = [
      {
        sourcePort = 25565;
        destination = "10.100.0.2:25565";
        proto = "tcp";
      }
    ];
  };

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
          server 10.100.0.2:25565;
      }

      server {
          listen 25565;
          proxy_pass minecraft_backend;
          proxy_timeout 1h;
      }
    '';
  };

  # NOTE: None of these ports will work unless you free them up!
  networking.firewall = {
    allowedUDPPorts = [51820];
    allowedTCPPorts = [80 443 22 25565]; # ← ADD 25565 HERE!
    checkReversePath = "loose";
    # allowForwardedTraffic = true;
  };
}
