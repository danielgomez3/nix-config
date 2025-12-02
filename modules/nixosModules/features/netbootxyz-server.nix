{pkgs, ...}: {
  services.tftpd = {
    enable = true;
    path = "/srv/tftp";
  };

  networking.firewall.allowedUDPPorts = [69]; # TFTP

  systemd.services.setup-netbootxyz = {
    description = "Setup netboot.xyz TFTP server";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /srv/tftp
      # Copy all netboot.xyz files to TFTP directory
      cp -r ${pkgs.netbootxyz-efi}/share/netboot.xyz/* /srv/tftp/

      # Set proper permissions
      chmod -R 644 /srv/tftp/
      find /srv/tftp/ -type d -exec chmod 755 {} \;
    '';
  };

  # Optional: DHCP server to automate network boot
  services.dhcpd4 = {
    enable = true;
    interfaces = ["eth0"];
    extraConfig = ''
      subnet 192.168.1.0 netmask 255.255.255.0 {
        range 192.168.1.100 192.168.1.200;
        option routers 192.168.1.1;
        # Point to netboot.xyz
        filename "ipxe.efi";
        next-server 192.168.1.50;  # Your server's IP
      }
    '';
  };
}
