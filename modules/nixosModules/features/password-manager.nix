{pkgs,...}:{

  myNixOS.vaultwarden.enable = true;

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    virtualHosts."server.tail1b372c.ts.net" = {
      enableACME = false;  # Disable Let's Encrypt
      forceSSL = false;    # Skip HTTPS enforcement (Tailscale already encrypts traffic)
      locations."/" = {
        proxyPass = "http://127.0.0.1:8000";  # Forward to Vaultwarden
      };
    };
  };

}
