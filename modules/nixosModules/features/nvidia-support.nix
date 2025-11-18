# nvidia-support.nix
{...}: {
  # hardware.nvidia.enabled = true; # already automatically enabled
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.open = false; # see the note above
}
