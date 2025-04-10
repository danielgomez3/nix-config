{pkgs,lib,...}:{

  environment.systemPackages = with pkgs; [
    cachix
  ];

  nix.settings.substituters = [
    "https://cachix.cachix.org"
  ];

}
