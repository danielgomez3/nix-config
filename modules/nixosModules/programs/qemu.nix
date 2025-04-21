{pkgs,...}:{
  environment = {
    systemPackages = [ pkgs.qemu ];
  };

  # virtualisation.qemu = {
  #   enable = true;
  # };
}
