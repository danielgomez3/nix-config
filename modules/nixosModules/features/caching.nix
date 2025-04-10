{pkgs,lib,...}:{

  environment.systemPackages = with pkgs; [
    cachix
  ];

  # For some reason couldn't use cachix unless I was a 'trust-user'
  nix.settings.trusted-users = [ "danielgomez3" ];

  nix.settings.substituters = [
    "https://cachix.cachix.org"
  ];

}
