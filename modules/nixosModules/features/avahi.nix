{...}: {
  services.avahi = {
    enable = true;
    nssmdns4 = true; # mDNS
    publish = {
      enable = true; # allow avahi to publish your information to other devices in lan
      addresses = true; # advertise the IP addr of your system
      domain = true; # advertise domain name from /etc/hostname
      hinfo = true; # publish harware info, like CPU and OS

      # Enables publishing of user-defined mDNS services.
      # These are .service files in /etc/avahi/services or /var/run/avahi/services.
      # For example: a printer or media server can be advertised to the network automatically.
      userServices = true;

      #Publishes your system as a generic workstation on the network.
      # This makes it show up in “Network” browsing on other machines without specifying individual services.
      workstation = true;
    };
  };
}
