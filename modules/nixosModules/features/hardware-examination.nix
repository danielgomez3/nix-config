# hardware-examination.nix
# TODO: this assumes AMD, make conditional for nvidia
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    dmidecode # detailed overview
    lshw # user-friendly
    nvtopPackages.amd
  ];
}
