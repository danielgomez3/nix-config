# docker.nix
# https://wiki.nixos.org/wiki/Docker#Rootless_Docker
# https://wiki.nixos.org/wiki/Docker#Using_Privileged_Ports_for_Rootless_Docker
{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = [pkgs.docker-compose];

  # # NOTE: Rootless Docker:
  # # This is buggy! Docker isn't really meant to run rootless.. Try podman?
  virtualisation.docker = {
    #   # Consider disabling the system wide Docker daemon
    enable = true;

    #   rootless = {
    #     enable = true;
    #     setSocketVariable = true;
    #     # Optionally customize rootless Docker daemon settings
    #     daemon.settings = {
    #       dns = ["1.1.1.1" "8.8.8.8"];
    #       registry-mirrors = ["https://mirror.gcr.io"];
    #     };
    #   };
  };
  # If true, systemd user units will start at boot, rather than starting at login and stopping at logout
  users.users.${config.myVars.username}.linger = true;

  # Disable this if rootless docker
  # users.users.<username>.extraGroups = [ "docker" ];
}
