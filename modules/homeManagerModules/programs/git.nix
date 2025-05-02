{
pkgs,
config,
...
}: {

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800; # Cache passphrase for 30 minutes
    # enableSshSupport = true;
    # pinentryFlavor = "gnome3"; # Use "qt", "curses", etc., based on your DE
  };

  programs.gpg.enable = true;

  programs.git = {
    enable = true;
    userName = "danielgomez3";
    userEmail = "danielgomezcoder@gmail.com";  # FIXME: use sops nix, but doesn't seem to work:     defaults.email = "${toString config.sops.secrets.email}";
    signing = {
      key = "B3A4F8E40987390C";  # FIXME: put in sops
      signByDefault = true;
    };

    extraConfig = {
      credential.helper = "store";
    };
  };

}

