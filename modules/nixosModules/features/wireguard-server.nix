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
in {
  # environment.systemPackages = [pkgs.wg];

  # Enable NAT for routing Minecraft traffic
  networking.nat.enable = true;
  networking.nat.externalInterface = "eth0"; # Change if different
  networking.nat.internalInterfaces = ["wg0"];

  networking.firewall = {
    allowedUDPPorts = [51820 25565]; # WireGuard + Minecraft
    allowedTCPPorts = [25565]; # Minecraft
  };

  # "wg0" is the network interface name. You can name the interface arbitrarily.
  networking.wireguard.interfaces.wg0 = {
    ips = ["10.100.0.1/24"]; # Determines the IP address and subnet of the server's end of the tunnel interface.
    listenPort = 51820; # The port that WireGuard listens to. Must be accessible by the client.

    # Path to the private key you generated
    privateKeyFile = config.sops.secrets."wireguard-private-key-file/${hostname}".path;

    peers = [
      # List of allowed peers (clients)
      {
        publicKey = "XAek67dqDTUuk94381DYI2bCHEdbC9l26tNH58FIUD8="; # home server's public key
        allowedIPs = ["10.100.0.2/32"]; # List of IPs assigned to this peer within the tunnel subnet.  Used to configure routing.

        # This keeps the connection alive through NAT
        persistentKeepalive = 25;
      }
    ];
  };
}
