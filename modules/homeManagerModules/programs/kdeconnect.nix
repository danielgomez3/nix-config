{pkgs,...}:{

  home.packages = with pkgs; [
    libsForQt5.kpeople # HACK: Get kde sms working properly
    libsForQt5.kpeoplevcard # HACK: Get kde sms working properly
  ];

  services.kdeconnect = {
    enable = true; 
    indicator = false;
  };

}
