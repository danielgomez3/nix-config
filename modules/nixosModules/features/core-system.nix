# NOTE: EVERY device should inherit this, without exception.
# Headless servers, all secure devices. Secure devices SHOULD NOT inherit base-system.nix
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  hapless = import "${inputs.self.outPath}/derivations/hapless.nix" {
    inherit (pkgs) lib fetchFromGitHub;
    python3 = pkgs.python312; # or python311
  };
in {
  myNixOS = {
    coding-environment.enable = lib.mkDefault true;
    openssh.enable = lib.mkDefault true;
    sops.enable = lib.mkDefault true;
  };
  home-manager.users.${config.myVars.username}.myHomeManager = {
    cli-apps.enable = lib.mkDefault true;
  };

  nixpkgs.overlays = [
    (final: prev: {
      # Create hapless with patched dependencies
      hapless = prev.python3.pkgs.buildPythonPackage rec {
        pname = "hapless";
        version = "0.14.0";

        src = prev.fetchFromGitHub {
          owner = "bmwant";
          repo = "hapless";
          rev = "v${version}";
          hash = "sha256-ivTW9epMHMpS41LWE+hsAF/m3OC+oIXKuFhkJki4EAg=";
        };

        format = "pyproject";

        nativeBuildInputs = with prev.python3.pkgs; [
          setuptools
          poetry-core
        ];

        propagatedBuildInputs = with prev.python3.pkgs; [
          click
          django-environ
          humanize
          psutil
          rich
          structlog
          typing-extensions
        ];

        # Patch the version requirements in pyproject.toml
        prePatch = ''
          substituteInPlace pyproject.toml \
            --replace 'psutil = "^6.1.0"' 'psutil = ">=6.1.0"' \
            --replace 'rich = "^13.5.2"' 'rich = ">=13.5.2"' \
            --replace 'typing-extensions = "4.0.0"' 'typing-extensions = ">=4.0.0"'
        '';

        # Skip the runtime dependency check that's failing
        # pythonRuntimeDepsCheck = false;

        pythonImportsCheck = ["hapless"];

        meta = with prev.lib; {
          description = "A Linux CLI tool called hapless";
          homepage = "https://github.com/hapless/hapless";
          license = licenses.mit;
          maintainers = with maintainers; [];
          mainProgram = "hapless";
        };
      };
    })
  ];

  system.stateVersion = "24.05";
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.allowed-uris = [
    "github:"
    "git+https://github.com/"
    "git+ssh://github.com/"
    "git+ssh://git@github.com/" # My secrets repository
    "git+ssh://git@github.com/danielgomez3/nix-secrets.git"
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  users = {
    # Define a user account. Don't forget to set a password with 'passwd'.
    mutableUsers = false; # Required for a password 'passwd' to be set via sops during system activation (over anything done imperatively)!
    users.root.hashedPasswordFile = config.sops.secrets.user_password.path;
    users.${config.myVars.username} = {
      hashedPasswordFile = config.sops.secrets.user_password.path;
      isNormalUser = true;
      extraGroups = ["wheel"];
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    pigz
    nftables
    iptables
    unixtools.netstat
    btop
    toybox
    busybox # telnet,
    openssl
    dig # check dns records
    mailutils # send mail via 'mail'
    sysz
    wireguard-tools
    fd
    hapless # This now uses the overridden version from the overlay
    procps
    nushell
  ];
}
