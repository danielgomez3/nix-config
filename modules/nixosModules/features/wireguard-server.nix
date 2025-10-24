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
}
