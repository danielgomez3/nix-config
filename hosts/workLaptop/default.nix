{
  pkgs,
  inputs,
  self,
  config,
  ...
}: {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  myVars.username = "dgomez";
  myVars.hostname = "workLaptop"; # Specific hostname for this machine
  myVars.isHardwareLimited = true;
  myVars.isSyncthingClient = true;

  users.users.${config.myVars.username} = {
    description = "macOS work laptop";
    home = "/Users/${config.myVars.username}";
  };

  networking.hostName = "${config.myVars.hostname}";
  users.users."normalUser" = {
    description = "My work macOS Laptop";
  };

  # environment.systemPackages = with pkgs; [
  #   kdePackages.kdeconnect-kde
  # ];

  # home-manager.users.${config.myVars.username}.home = {
  #   stateVersion = "24.05";
  #   # username = config.myVars.username;
  #   # homeDirectory = "/Users/${config.myVars.username}";
  #   packages = with pkgs; [
  #     iterm2
  #   ];
  # };

  home-manager.extraSpecialArgs = {inherit self;};
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Auto upgrade nix package
  # nix.package = pkgs.nix;

  ## NOTE: Abstract the following in an aarch64 darwin file:
  #

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
  # ids.gids.nixbld = 350;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";
  nixpkgs.config.allowBroken = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
  # nixpkgs.overlays = [ ];

  ## NOTE: darwin services
  services.tailscale.enable = true;

  ## NOTE: macOS desktop experience preferences
  system.defaults.dock = {
    autohide = true;
  };

  system.defaults.NSGlobalDomain._HIHideMenuBar = true;

  ## NOTE Use Homebrew for stuff that can't be installed via NIXPKGS

  # XXX: Make sure this works on a brand new system. I have a suspicion this starts too late, after homebrew tries to install crap..
  system.activationScripts.postUserActivation.text = ''
    # Fix Homebrew directory permissions
    if [ -d "/usr/local/var/log" ]; then
      echo "Fixing Homebrew directory permissions..."
      sudo chown -R "${config.myVars.username}" /usr/local/var/log
      chmod u+w /usr/local/var/log
    fi
  '';

  nix-homebrew.enable = true;
  nix-homebrew.user = "${config.myVars.username}";
  homebrew = {
    enable = true;
    # onActivation.cleanup = "uninstall";

    taps = [];
    brews = ["cowsay"];
    casks = ["firefox" "zed" "ghostty" "kitty" "xournal++"];
  };
}
