# minecraft-server-docker.nix
{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [pkgs.docker-compose];
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers.rlcraft = {
    image = "itzg/minecraft-server:java8";
    autoStart = true;

    # FIXME: This worked for now, but may be impure!
    # I think it's becuase these already existed?
    volumes = [
      "/var/lib/minecraft/rlcraft/data:/data"
      "/var/lib/minecraft/rlcraft/mods:/mods"
      "/var/lib/minecraft/rlcraft/config:/config"
      "/var/lib/minecraft/rlcraft/plugins:/plugins"

      # Mount your existing world (optional - if you want to restore from backup)
      # "/path/to/your/existing/world:/data/world:ro"
    ];

    environment = {
      EULA = "true";
      TYPE = "AUTO_CURSEFORGE";
      CF_API_KEY = "$2a$10$2SWjY9ditvIAUbdZuX93WeENk3rfXKSBlJea1g3U2UC41fTjtwoky";
      CF_SLUG = "rlcraft"; # The modpack slug from CurseForge URL
      CF_PAGE_URL = "https://www.curseforge.com/minecraft/modpacks/rlcraft";
      OVERRIDE_SERVER_PROPERTIES = "true";
      DIFFICULTY = "hard";
      MAX_TICK_TIME = "-1";
      ALLOW_FLIGHT = "false";
      ENABLE_COMMAND_BLOCK = "true";
      VIEW_DISTANCE = "25";
      MEMORY = "8G";
      OPS = "LittleBee_\njodango2814\nWorthyDragoon94";
      RCON_CMDS_STARTUP = "gamerule keepInventory true";
      # WORLD = "http://danielgomezcoder.org/minecraft/world-saves/rlcraft/rlcraft-cdb_2025-10-30/World.zip"; # XXX: this is impure! Server depends on itself to already exist! Invest in blob storage for now or smth idk
    };

    ports = ["25565:25565"];
  };

  # Open the Minecraft server port in the firewall
  networking.firewall.allowedTCPPorts = [25565];
}
