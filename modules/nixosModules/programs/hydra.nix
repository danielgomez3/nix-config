{config, pkgs,lib,...}:{

  users.users.hydra = (lib.mkIf config.services.hydra.enable {
    hashedPasswordFile = config.sops.secrets.user_password.path;  
  });

  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000"; # externally visible URL
    notificationSender = "danielgomezcoder@gmail.com"; # e-mail of hydra service
    # a standalone hydra will require you to unset the buildMachinesFiles list to avoid using a nonexistant /etc/nix/machines
    buildMachinesFiles = [
      # "/etc/nix/machines"
      # "/var/lib/hydra/provisioner/machines"
    ];
    # you will probably also want, otherwise *everything* will be built from scratch
    useSubstitutes = true;
    # extraConfig = ''
    #   binary_cache_public_uri = http://localhost:3000
    # '';
  };
}
