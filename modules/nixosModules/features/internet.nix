{ self, config, pkgs, lib, inputs, name, ... }:
let 
  # nvChad = import ./derivations/nvchad.nix { inherit pkgs; };
  # cutefetch = import ./derivations/cutefetch.nix { inherit pkgs; };  # FIX attempting w/home-manager
  username = config.myVars.username;
in
{
  # Set your time zone.
  time.timeZone = "America/New_York";
  systemd.services.NetworkManager-wait-online.enable = false;
  networking = {
    hostName = name;  # Define your hostname.
    # nameservers = [ "8.8.8.8" "8.8.4.4" ];
    dhcpcd.enable = true;
    # domain = "home";
    firewall = {
      enable = false;
      # always allow traffic from your Tailscale network
      trustedInterfaces = [ "tailscale0"];
      # Open the necessary UDP ports for PXE boot
      allowedUDPPorts = [ 
        67 69 4011 config.services.tailscale.port
      ];
      # Open the necessary TCP port for Pixiecore
      allowedTCPPorts = [ 
        22
        80
        443
        64172 
      ];
      allowPing = true;     # Optional: Allow ICMP (ping)
      # Set default policies to 'accept' for both incoming and outgoing traffic
    };
    # firewall.allowedUDPPorts = [ 67 69 4011 ];
    # firewall.allowedTCPPorts = [ 64172 ];

    # Enables WPA_SUPPLICANT
    # wireless = {
    #   enable = true;
    #   # Declarative configuration
    #   secretsFile = config.sops.secrets."wireless.env".path;
    #   networks = {
    #     # "${config.sops.secrets.wifi_networks/home/ssid}" = {
    #     "maple" = {  # FIXME: this is bad. Shouldn't reveal any information
    #       # psk = "naruto88";
    #       # psk = "@home_psk@";
    #       pskRaw = "ext:home_psk";
    #     };
    #   };
    #   # Imperative configuration https://github.com/percygt/nix-dots/blob/f25f89bf97c917c7b096d384c2b3c510cb6ae4c5/modules/core/wpa_supplicant.nix#L24
    #   allowAuxiliaryImperativeNetworks = true;
    #   userControlled = {
    #     enable = true;
    #     # group = "network";
    #   };
    #   # extraConfig = ''
    #   #   update_config=1
    #   # '';
    # };
  };
}


