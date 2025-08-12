{
  pkgs,
  config,
  ...
}: {
  sops.secrets = {
    "vaultwarden-env" = {
      owner = "vaultwarden";
      group = "vaultwarden";
    };
    CLOUDFLARE_API_KEY = {};
    CLOUDFLARE_EMAIL = {};
  };

  services.vaultwarden = {
    enable = false;
    backupDir = "/var/lib/vaultwarden/backup";
    # in order to avoid having  ADMIN_TOKEN in the nix store it can be also set with the help of an environment file
    # be aware that this file must be created by hand (or via secrets management like sops)
    environmentFile = config.sops.secrets.vaultwarden-env.path;
    config = {
      # Refer to https://github.com/dani-garcia/vaultwarden/blob/main/.env.template
      DOMAIN = "https://vault.danielgomezcoder.org";
      SIGNUPS_ALLOWED = false;

      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";

      # This example assumes a mailserver running on localhost,
      # thus without transport encryption.
      # If you use an external mail server, follow:
      #   https://github.com/dani-garcia/vaultwarden/wiki/SMTP-configuration
      SMTP_HOST = "smtp.gmail.com";
      SMTP_PORT = 465;
      SMTP_SECURITY = "force_tls";

      SMTP_FROM = "danielgomezcoder@gmail.com";
      # SMTP_FROM_NAME = "My Password Manager";
      SMTP_USERNAME = "danielgomezcoder@gmail.com";
      SMTP_PASSWORD = "dchw naon fmyi dcep";
    };
  };
  # security.acme = {
  #   acceptTerms = true;
  #   defaults = {
  #     email = "danielgomezcoder@gmail.com";
  #     dnsProvider = "cloudflare";
  #     credentialFiles = let
  #       s = config.sops.secrets;
  #     in {
  #       CLOUDFLARE_API_KEY_FILE = s.CLOUDFLARE_API_KEY.path;
  #       CLOUDFLARE_EMAIL_FILE = s.CLOUDFLARE_EMAIL.path;
  #     };
  #     dnsResolver = "1.1.1.1:53";
  #   };
  # };
  # Reverse Proxy
  # services.caddy.virtualHosts."vault.danielgomezcoder.org".extraConfig = ''
  #   encode zstd gzip

  #   reverse_proxy :${toString config.services.vaultwarden.config.ROCKET_PORT} {
  #       header_up X-Real-IP {remote_host}
  #   }
  # '';
  # services.nginx.virtualHosts."danielgomezcoder.org".acmeRoot = null;
  # services.nginx.enable = true;
  # services.nginx.virtualHosts."danielgomezcoder@gmail.com" = {
  #   enableACME = true;
  #   forceSSL = true;
  #   locations."/" = {
  #     proxyPass = "http://localhost:${toString config.services.vaultwarden.config.ROCKET_PORT}";
  #   };
  # };
}
