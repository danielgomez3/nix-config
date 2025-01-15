{pkgs,lib,...}:{
  # https://wiki.nixos.org/wiki/Printing
  services = {
    # Enable CUPS to print documents.
    printing.enable = true;
    printing.drivers = [ pkgs.brlaser ];
    # Enable autodescovery of network printers
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    # Maybe drivers needed too...
    # printing.drivers = [ YOUR_DRIVER ];

  };
}
