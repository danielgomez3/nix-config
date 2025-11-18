# wifi-config.nix
# TODO: This is crap. make this work: a declarative wifi setup.
{inputs, ...}: {
  networking.networkmanager.ensureProfiles.environmentFiles = [
    inputs.config.sops.secrets."wifi_home.env".path
  ];
}
