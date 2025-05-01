{
pkgs,
config,
...
}: {

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800; # Cache passphrase for 30 minutes
    # pinentryFlavor = "gnome3"; # Use "qt", "curses", etc., based on your DE
  };

  programs.gpg.enable = true;

  programs.git = {
    enable = true;
    userName = "danielgomez3";
    userEmail = "danielgomezcoder@gmail.com";  # FIXME: use sops nix, but doesn't seem to work:     defaults.email = "${toString config.sops.secrets.email}";
    signing = {
      key = "480228117EAA56B7";  # FIXME: put in sops
      signByDefault = true;
    };

    extraConfig = {
      credential.helper = "store";
      gpg.format = "ssh";
    };
  };

}

