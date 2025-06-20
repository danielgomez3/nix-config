{
  pkgs,
  config,
  ...
}: {
  #
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
    userEmail = "danielgomezcoder@gmail.com";
    signing = {
      # gpg --list-secret-keys --keyid-format=long
      key = "B3A4F8E40987390C"; # FIXME: put in sops, or put private key somewhere??
      signByDefault = true;
    };

    extraConfig = {
      # https://jeppesen.io/git-commit-sign-nix-home-manager-ssh/
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
    delta = {
      enable = true;
      options = {
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "none";
          file-style = "bold yellow ul";
        };
        features = "decorations";
        whitespace-error-style = "22 reverse";
      };
    };
  };
}
