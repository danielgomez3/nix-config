{ config, lib, pkgs, self, ... }:
{

  # https://wiki.nixos.org/wiki/Sway
  services.greetd = {                                                      
    enable = true;                                                         
    vt = 2;
    settings = {                                                           
      default_session = {                                                  
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";                                                  
      };                                                                   
    };                                                                     
  };


}
