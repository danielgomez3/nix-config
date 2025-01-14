{
pkgs,
config,
...
}: {

  git = {
    enable = true;
    userName = "danielgomez3";
    userEmail = "danielgomezcoder@gmail.com";  # FIXME: use sops nix, but doesn't seem to work:     defaults.email = "${toString config.sops.secrets.email}";

    extraConfig = {
      credential.helper = "store";
    };
  };

}

