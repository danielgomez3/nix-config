# NOTE:
# acts as a relay/mx-front
{...}: let
  domain = "danielgomezcoder.org";
  wgTunnelIP = "10.100.0.1/24";
in {
  services.maddy = {
    enable = true;
    primaryDomain = domain;
    openFirewall = false; # only accessible through your tunnel

    # No ACME here — it can use a local cert or be behind the VPN
    tls = {
      loader = "file";
      certificates = [
        {
          key_path = "/etc/ssl/private/maddy.key";
          cert_path = "/etc/ssl/certs/maddy.crt";
        }
      ];
    };

    ensureAccounts = [
      "postmaster@danielgomezcoder.org"
      "daniel@danielgomezcoder.org"
    ];

    # Read passwords from secrets (use sops)
    ensureCredentials = {
      "postmaster@danielgomezcoder.org".passwordFile = "/run/secrets/maddy-postmaster";
      "daniel@danielgomezcoder.org".passwordFile = "/run/secrets/maddy-daniel";
    };

    config = ''
      imap tls://0.0.0.0:993
      submission tls://0.0.0.0:465

      auth.pass_table localdb
      auth.check_pass localdb

      target.local {
        deliver_to maildir /var/lib/maddy/mailboxes/%{user}
      }

      mda local_delivery {
        destination danielgomezcoder.org
        deliver_to local
      }

      dmarc yes
    '';
  };

  networking.firewall.allowedTCPPorts = [993 465];
}
