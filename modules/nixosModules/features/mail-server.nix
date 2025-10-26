# mail-server.nix
{
  config,
  pkgs,
  options,
  ...
}: {
  # Enable NixOS native ACME for certificate management
  security.acme = {
    acceptTerms = true;
    defaults.email = "danielgomezcoder@gmail.com";

    certs."danielgomezcoder.org" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.secrets."CLOUDFLARE_API_KEY".path;
      # Make certificates accessible to maddy
      group = config.services.maddy.group;
      reloadServices = ["maddy.service"];
    };
  };

  services.maddy = {
    enable = true;
    openFirewall = true;
    primaryDomain = "danielgomezcoder.org";
    hostname = "mail.danielgomezcoder.org";

    tls = {
      loader = "file";
      certificates = [
        {
          certPath = config.security.acme.certs."danielgomezcoder.org".directory + "/fullchain.pem";
          keyPath = config.security.acme.certs."danielgomezcoder.org".directory + "/key.pem";
        }
      ];
    };

    # Enable TLS listeners
    config = ''
      state_dir /var/lib/maddy
      ${builtins.replaceStrings [
          "imap tcp://0.0.0.0:143"
          "submission tcp://0.0.0.0:587"
        ] [
          "imap tls://0.0.0.0:993 tcp://0.0.0.0:143"
          "submission tls://0.0.0.0:465 tcp://0.0.0.0:587"
        ]
        options.services.maddy.config.default}
    '';

    # Create accounts for your domain
    ensureAccounts = [
      "danielgomez3@danielgomezcoder.org"
      "postmaster@danielgomezcoder.org"
    ];

    # Set up credentials (use secure files)
    ensureCredentials = {
      "danielgomez3@danielgomezcoder.org".passwordFile = "${pkgs.writeText "danielgomez3" "test"}";
      "postmaster@danielgomezcoder.org".passwordFile = "${pkgs.writeText "postmaster" "test"}";
    };

    # Cloudflare API token secret
    secrets = [config.sops.secrets."CLOUDFLARE_API_KEY".path];
  };

  # Opening ports for additional TLS listeners
  networking.firewall.allowedTCPPorts = [993 465];

  # NOTE Relays outgoing mail to google, and you can do it via the CLI! Works, not necessary.
  # programs.msmtp = {
  #   enable = true;
  #   defaults = {
  #     auth = true;
  #     tls = true;
  #     tls_starttls = true;
  #     # If sendmail hangs, try setting this to false:
  #     # tls_starttls = false;
  #   };
  #   accounts = {
  #     default = {
  #       host = "smtp.gmail.com";
  #       port = 587;
  #       from = "danielgomez3@danielgomezcoder.org"; # Your FROM address
  #       user = "danielgomezcoder@gmail.com"; # Your Gmail address
  #       passwordeval = "cat ${config.sops.secrets."gmail_app_password".path}";
  #     };
  #   };
  # };

  # services.postfix = {
  #   enable = true;
  #   # relayHost = "smtp.gmail.com";
  #   # relayPort = 587;
  #   settings.main.relayhost = ["smtp.gmail.com:587"];
  #   config = {
  #     smtp_use_tls = "yes";
  #     smtp_sasl_auth_enable = "yes";
  #     smtp_sasl_security_options = "";
  #     smtp_sasl_password_maps = "texthash:${config.sops.secrets."postfix/sasl_passwd".path}";
  #     # optional: Forward mails to root (e.g. from cron jobs, smartd)
  #     # to me privately and to my work email:
  #     # virtual_alias_maps = "inline:{ {root=you@gmail.com, you@work.com} }";
  #   };
  # };
}
