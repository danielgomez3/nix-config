{
  self,
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  # nvChad = import ./derivations/nvchad.nix { inherit pkgs; };
  # cutefetch = import ./derivations/cutefetch.nix { inherit pkgs; };  # FIX attempting w/home-manager
  username = config.myVars.username;
  hostname = config.myVars.hostname;
in {
  # Set your time zone.
  time.hardwareClockInLocalTime = true; # TODO this is in desktop too.
  time.timeZone = "America/New_York";
  networking = {
    hostName = hostname; # Define your hostname.
    # nameservers = [ "8.8.8.8" "8.8.4.4" ];
    dhcpcd.enable = true;
    # domain = "home";
    firewall = {
      enable = false;
      # always allow traffic from your Tailscale network
      trustedInterfaces = ["tailscale0"];
      # Open the necessary UDP ports for PXE boot
      allowedUDPPorts = [
        67
        69
        4011
        41641 # tailscale UDP port
      ];
      # Open the necessary TCP port for Pixiecore
      allowedTCPPorts = [
        22
        80
        64172
        8787
        443 # tailscale TCP port
      ];
      allowPing = true; # Optional: Allow ICMP (ping)
      # Set default policies to 'accept' for both incoming and outgoing traffic
    };
    # firewall.allowedUDPPorts = [ 67 69 4011 ];
    # firewall.allowedTCPPorts = [ 64172 ];
  };
}
