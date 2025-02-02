{pkgs,lib,...}:{
  # https://nixos.wiki/wiki/Logind
  # Logind is systemd's login manager
  # FIXME: Does not work! This is just to get my laptop to suspend on lid close :(
  services.logind = {
    lidSwitch = "suspend";  # Suspend on lid close
    lidSwitchDocked = "ignore";  # Don't suspend when an external monitor is connected
    lidSwitchExternalPower = "suspend";  # Suspend even when on AC power
    extraConfig = ''
      HandleLidSwitch=suspend
    '';
  };
}
