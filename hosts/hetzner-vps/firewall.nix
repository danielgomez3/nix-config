# hosts/hetzner-vps/firewall.nix
{
  config,
  pkgs,
  ...
}: let
  ports = config.myVars.ports;
in {
  networking.nat = {
    enable = true;
    externalInterface = "eth0";
    internalInterfaces = ["wg0"];
    forwardPorts = [
      {
        sourcePort = ports.mc;
        destination = "10.100.0.2:${toString ports.mc}";
        proto = "tcp";
      }
    ];
  };

  networking.firewall = {
    allowedUDPPorts = [51820];
    allowedTCPPorts = [22 80 443 ports.mc];
    # allowForwardedTraffic = true;
  };
}
