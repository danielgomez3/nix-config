# wifi-config.nix
# TODO: make this work. Make a declarative wifi setup.
{inputs, ...}: {
  networking.networkmanager.ensureProfiles.environmentFiles = [
    inputs.config.sops.secrets."wifi_home.env".path
  ];
}
