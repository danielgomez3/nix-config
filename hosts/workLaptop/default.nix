{pkgs, self,...}:{

  networking.hostName = "workLaptop";
  users.users."normalUser" = {
    description = "My work macOS Laptop";
  };

  environment.systemPackages =
    [ pkgs.vim pkgs.lolcat
    ];

  # Auto upgrade nix package 
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
  ids.gids.nixbld = 350;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";  
  home-manager = {
    extraSpecialArgs = { inherit self; };
  };



}
