{
pkgs,
config,
...
}: {

  programs.git = {
    enable = true;
    userName = "danielgomez3";
    userEmail = "danielgomezcoder@gmail.com";  # FIXME: use sops nix, but doesn't seem to work:     defaults.email = "${toString config.sops.secrets.email}";
    signing = {
      key = "6D55D3035B3FE40402D8E8AE480228117EAA56B7";
      signByDefault = true;
    };

    extraConfig = {
      credential.helper = "store";
      gpg.format = "ssh";
    };
  };

}

