{ config, pkgs, pkgsUnstable, lib, inputs,  ... }:
let 
  username = config.myVars.username;
in
{
    environment.variables.EDITOR = "${pkgsUnstable.helix}";
    # TODO: make sql crap as HM module sql.nix instead
    # services.mysql = {
    #   enable = true;
    #   package = pkgs.mariadb;
    #   dataDir = "/var/lib/mysql";
    #   ensureUsers = [
    #     {
    #       name = "root";
    #       ensurePermissions = {
    #         "*.*" = "ALL PRIVILEGES";
    #       };
    #     }
    #   ];
    # };
}
