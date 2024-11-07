# hive.nix
{
  # SSH user for all remote hosts
  meta.sshUser = "daniel";  # Default SSH user (change per-host below if necessary)

  # Define hosts and their configurations
  nodes = {
    desktop = {
      hostname = "desktop";
      address = "danielgomezcoder-d.duckdns.org";  # Replace with the actual IP or hostname
      sshUser = "daniel";           # Override if necessary
      deploy = {
        flake = "./#desktop";
      };
    };

    laptop = {
      hostname = "laptop";
      address = "danielgomezcoder-l.duckdns.org";  # Replace with the actual IP or hostname
      sshUser = "daniel";
      deploy = {
        flake = "./#laptop";
      };
    };

    server = {
      hostname = "server";
      address = "danielgomezcoder-s.duckdns.org";  # Replace with the actual IP or hostname
      sshUser = "danielgomez3";
      deploy = {
        flake = "./#server";
      };
    };
  };
}
