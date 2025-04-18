{pkgs,lib,inputs,...}:{

  imports = [ inputs.nix-netboot-serve.nixosModules.nix-netboot-serve ];
  services.nix-netboot-serve = {
    enable = true;
    listen = "0.0.0.0:3030";
  };
}

