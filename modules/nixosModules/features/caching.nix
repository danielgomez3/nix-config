{pkgs,lib,...}:{

  environment.systemPackages = with pkgs; [
    cachix
  ];

  # For some reason couldn't use cachix unless I was a 'trust-user'
  nix.settings.trusted-users = [ "danielgomez3" ];

  nix.settings.substituters = [
    "https://cachix.cachix.org"
  ];

  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-on-droid.cachix.org-1:56snoMJTXmDRC1Ei24CmKoUqvHJ9XCp+nidK7qkMQrU="
  ];


}
