# minecraft-server-docker.nix
{config, ...}: {
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers.rlcraft = {
    image = "itzg/minecraft-server:java8";
    autoStart = true;

    volumes = [
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
    };

    ports = ["25565:25565"];
  };

  # Open the Minecraft server port in the firewall
  networking.firewall.allowedTCPPorts = [25565];
}
