# minecraft-server
# https://www.youtube.com/watch?v=Fph7SMldxpI
{
  pkgs,
  config,
  ...
}: let
in {
  # NOTE: Standard minecraft server:
  services.minecraft-server = {
    enable = true;
    package = pkgs.minecraftServers.vanilla-1-21;
    eula = true;
    openFirewall = true;
    dataDir = "/var/lib/minecraft";
    declarative = true;
    serverProperties = {
      server-port = 25565; # TODO make this a global var, so wireguard-clients and servers don't ever mismatch
      difficulty = 3;
      gamemode = 0;
      max-players = 20;
      motd = "Danny's Minecraft server! Big bipple yip snip on the fukalatang gewnow. Heavy gewt. On yang.";
      white-list = true;
      enable-rcon = true;
      "rcon.password" = config.sops.secrets.generic-pass.path;
      # level-seed = "4";
    };
    whitelist = {
      danny = "bd690296-8253-4d62-9fa8-41b255f55696";
      chris = "ef84e37f-5abe-4992-9d70-85f50c05de3f";
      # username2 = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy";
    };
  };
  # Or manually open the port if not using the minecraft-server module
  # networking.firewall.allowedTCPPorts = [25565 80 443];
}
