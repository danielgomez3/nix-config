{pkgs,...}:{
  

  home.packages = with pkgs; [libcanberra];
  services.mako = {
    enable = true;
  };

}
