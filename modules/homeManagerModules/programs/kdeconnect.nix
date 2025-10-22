{pkgs, ...}: {
  # home.packages = with pkgs; [
  #   kdePackages.kpeople # HACK: Get kde sms working properly
  #   kdePackages.kpeoplevcard # HACK: Get kde sms working properly
  # ];

  services.kdeconnect = {
    enable = true;
    indicator = false;
  };
}
