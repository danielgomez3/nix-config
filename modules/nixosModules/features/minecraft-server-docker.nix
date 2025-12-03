# minecraft-server-docker.nix
# NOTE check if new API key config with sops actually works.
{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [pkgs.docker-compose];
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers = {
    rlcraft = {
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
        CF_SLUG = "rlcraft"; # The modpack slug from CurseForge URL
        CF_PAGE_URL = "https://www.curseforge.com/minecraft/modpacks/rlcraft";
        OVERRIDE_SERVER_PROPERTIES = "true";
        DIFFICULTY = "hard";
        MAX_TICK_TIME = "-1";
        ALLOW_FLIGHT = "true";
        ENABLE_COMMAND_BLOCK = "true";
        VIEW_DISTANCE = "25";
        MEMORY = "8G";
        OPS = "LittleBee_\njodango2814\nWorthyDragoon94\nYBG_Dong1";
        # ENABLE_RCON = "true"; # XXX: doesn't belong here
        RCON_CMDS_STARTUP = "gamerule keepInventory true";
        # WORLD = "http://danielgomezcoder.org/minecraft/world-saves/rlcraft/rlcraft-cdb_2025-10-30/World.zip"; # XXX: this is impure! Server depends on itself to already exist! Invest in blob storage for now or smth idk
      };
      # FIXME: check if this is actually working/reproducible..
      environmentFiles = [
        config.sops.templates."minecraft-cf-api-key".path
      ];

      ports = ["25565:25565"];
    };
  };

  # TODO: WIP
  # virtualisation.oci-containers.containers.nightfallcraft = {
  #   image = "itzg/minecraft-server:java8";
  #   autoStart = true;
  #   volumes = [
  #     "/var/lib/minecraft/nightfallcraft/data:/data"
  #     "/var/lib/minecraft/nightfallcraft/mods:/mods"
  #     "/var/lib/minecraft/nightfallcraft/config:/config"
  #     "/var/lib/minecraft/nightfallcraft/plugins:/plugins"

  #     # Mount your existing world (optional - if you want to restore from backup)
  #     # "/path/to/your/existing/world:/data/world:ro"
  #   ];

  #   environment = {
  #     EULA = "true";
  #     TYPE = "AUTO_CURSEFORGE";
  #     # NOTE fill if necessary..
  #     # CF_API_KEY = "";
  #     CF_SLUG = "nightfallcraft"; # The modpack slug from CurseForge URL
  #     CF_PAGE_URL = "https://www.curseforge.com/minecraft/modpacks/nightfallcraft-the-casket-of-reveries";

  #     OVERRIDE_SERVER_PROPERTIES = "true";
  #     DIFFICULTY = "hard";
  #     MAX_TICK_TIME = "-1";
  #     ALLOW_FLIGHT = "true";
  #     ENABLE_COMMAND_BLOCK = "true";
  #     VIEW_DISTANCE = "25";
  #     MEMORY = "8G";
  #     OPS = "LittleBee_\njodango2814\nWorthyDragoon94\nYBG_Dong1";
  #     # ENABLE_RCON = "true"; # XXX: doesn't belong here
  #     RCON_CMDS_STARTUP = "gamerule keepInventory true";
  #     # WORLD = "http://danielgomezcoder.org/minecraft/world-saves/nightfallcraft/nightfallcraft-cdb_2025-10-30/World.zip"; # XXX: this is impure! Server depends on itself to already exist! Invest in blob storage for now or smth idk
  #   };
  #   # FIXME: check if this is actually working/reproducible..
  #   environmentFiles = [
  #     config.sops.secrets."minecraft/CF_API_KEY".path
  #   ];

  #   ports = ["25565:25565"];
  # };

  # Open the Minecraft server port in the firewall
  networking.firewall.allowedTCPPorts = [25565];
}
