{inputs, ...}: {
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
    # inputs.nix-flatpak.homeManagerModules.nix-flatpak
    # inputs.flatpaks.homeManagerModules.nix-flatpak
  ];
  services.flatpak.enable = true;
  services.flatpak.packages = [
    {
      appId = "org.vinegarhq.Sober";
      origin = "flathub";
    }
  ];
}
