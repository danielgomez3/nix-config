{pkgs,...}:{
  

  home.packages = with pkgs; [libcanberra-gtk3];
  services.mako = {
    enable = true;
  };

}
