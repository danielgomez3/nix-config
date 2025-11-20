# base-system.nix
# NOTE: different than core-system because this only should be inherited by personal, powerful, headed or headless x86/64 machines, that are NOT darwin or etc.
# FIXME: This is insecure and casual because we implement a password login. DO NO INHERIT if you expose your server to the internet!!!
{
  pkgs,
  lib,
  config,
  inputs,
  self,
  ...
}: let
  hapless = import "${inputs.self.outPath}/derivations/hapless.nix" {
    inherit (pkgs) lib fetchFromGitHub;
    python3 = pkgs.python312; # or python311
  };
  username = config.myVars.username;
in {
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     # Create hapless with patched dependencies
  #     hapless = prev.python3.pkgs.buildPythonPackage rec {
  #       pname = "hapless";
  #       version = "0.14.0";

  #       src = prev.fetchFromGitHub {
  #         owner = "bmwant";
  #         repo = "hapless";
  #         rev = "v${version}";
  #         hash = "sha256-ivTW9epMHMpS41LWE+hsAF/m3OC+oIXKuFhkJki4EAg=";
  #       };

  #       format = "pyproject";

  #       nativeBuildInputs = with prev.python3.pkgs; [
  #         setuptools
  #         poetry-core
  #       ];

  #       propagatedBuildInputs = with prev.python3.pkgs; [
  #         click
  #         django-environ
  #         humanize
  #         psutil
  #         rich
  #         structlog
  #         typing-extensions
  #       ];

  #       # Patch the version requirements in pyproject.toml
  #       prePatch = ''
  #         substituteInPlace pyproject.toml \
  #           --replace 'psutil = "^6.1.0"' 'psutil = ">=6.1.0"' \
  #           --replace 'rich = "^13.5.2"' 'rich = ">=13.5.2"' \
  #           --replace 'typing-extensions = "4.0.0"' 'typing-extensions = ">=4.0.0"'
  #       '';

  #       # Skip the runtime dependency check that's failing
  #       # pythonRuntimeDepsCheck = false;

  #       pythonImportsCheck = ["hapless"];

  #       meta = with prev.lib; {
  #         description = "A Linux CLI tool called hapless";
  #         homepage = "https://github.com/hapless/hapless";
  #         license = licenses.mit;
  #         maintainers = with maintainers; [];
  #         mainProgram = "hapless";
  #       };
  #     };
  #   })
  # ];
  myNixOS = {
    systemd-boot.enable = lib.mkDefault true; # FIXME: does a base system need this? Or anyone at all?
    core-system.enable = lib.mkDefault true;
    hardware-examination.enable = lib.mkDefault true;
    coding-environment.enable = lib.mkDefault true;
    avahi.enable = lib.mkDefault true;
    network-config.enable = lib.mkDefault true;
    tailscale.enable = lib.mkDefault false;
    stylix.enable = lib.mkDefault true;
    good-repl-access.enable = lib.mkDefault true;
    fonts.enable = lib.mkDefault true; # TODO change where fonts go, this could be too big
    gnupg.enable = lib.mkDefault false;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];
  environment = {
    systemPackages = with pkgs; [
      # hapless # This now uses the overridden version from the overlay
      cmatrix
      jmtpfs # For interfacing with my OP-1 Field.
      woeusb
      ntfs3g
      nushell
      waypipe # x11 forwarding alternative:
      age
      nix-tree
    ];
  };
}
