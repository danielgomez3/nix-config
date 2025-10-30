# # nixcraft.nix
# # TODO: make this automatically imported
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  # Fetch any mrpack which can be used with both servers and clients!
  zombieModpack = pkgs.fetchurl {
    url = "https://cdn.modrinth.com/data/5sHFy7O5/versions/s3YT0ClF/Zombie%20Apocalypse%201.1.mrpack";
    hash = "sha256-3JuHm9VtasgBSCUt+iXAk30XHi8RBJNYxkGY0f+pdgc=";
  };
  # custom-danny-modpack = pkgs.fetchurl {
  #   url = "http://danielgomezcoder.org/minecraft/modpacks/Minecraft%20Adventure%20Modpack-1.0.0.mrpack";
  #   hash = "sha256-zRYOhB/kdBKuCZL1dPWQD+ImrvzIW0/YbwE59r37Hdg=";
  # };
in {
  #   imports = [
  #     # Import the nixcraft home module
  #     inputs.nixcraft.homeModules.default
  #   ];
  #   config = {
  #     nixcraft = {
  #       /*
  #       * Options starting with underscore such as _clientSettings are for advanced use case
  #       * Most instance options (such as java, mod loaders) are generic. There are also client/server specific options
  #       * Options are mostly inferred to avoid duplication.
  #         Ex: minecraft versions and mod loader versions are automatically inferred if mrpack is set
  #       * Instances are placed under ~/.local/share/nixcraft/client/instances/<name> or ~/.local/share/nixcraft/server/instances/<name>
  #       * Executable to run the instance will be put in path as nixcraft-<server/client>-<name>
  #       * Ex: nixcraft-client-myclient
  #       * See the binEntry option for customization
  #       * Read files found under submodules for more options
  #       * Read submodules/genericInstanceModule.nix for generic options
  #       */
  #       enable = true;
  #       server = {
  #         # Config shared with all instances
  #         shared = {
  #           agreeToEula = true;
  #           serverProperties = {
  #             server-port = 25565; # TODO make this a global var, so wireguard-clients and servers don't ever mismatch
  #             difficulty = 3;
  #             gamemode = 0;
  #             max-players = 20;
  #             motd = "Hey there";
  #             white-list = true;
  #             # enable-rcon = true;
  #             # "rcon.password" = config.sops.secrets.generic-pass.path;
  #             online-mode = true;
  #             "view-distance" = 20; # Default is 10, max is 32
  #             "simulation-distance" = 15; # Default is 8, max is 32
  #           };
  #           binEntry.enable = true;
  #         };
  #         instances = {
  #           # Example server with bare fabric loader
  #           # smp = {
  #           #   enable = true;
  #           #   version = "1.21.1";
  #           #   fabricLoader = {
  #           #     enable = true;
  #           #     version = "0.17.2";
  #           #   };
  #           # };
  #           # zombie-modpack = {
  #           #   enable = true;
  #           #   mrpack = {
  #           #     enable = true;
  #           #     file = zombieModpack;
  #           #   };
  #           #   java = {
  #           #     memory = 8000;
  #           #     # extraArguments = [
  #           #     #   "-XX:+UseG1GC"
  #           #     #   "-XX:+UnlockExperimentalVMOptions"
  #           #     #   "-XX:G1NewSizePercent=20"
  #           #     #   "-XX:G1ReservePercent=20"
  #           #     #   "-XX:MaxGCPauseMillis=50"
  #           #     #   "-XX:G1HeapRegionSize=32M"
  #           #     # ];
  #           #   };
  #           #   serverProperties = {
  #           #     # level-seed = "asdf";
  #           #     # online-mode = true; # Can be set here too!
  #           #     bug-report-link = null;
  #           #   };
  #           # };
  #           #   # servers can be run as systemd user services
  #           #   # service name is set as nixcraft-server-<name>.service
  #           #   service = {
  #           #     enable = true;
  #           #     autoStart = true;
  #           #   };
  #           #   files = {
  #           #     "whitelist.json".text = ''
  #           #       [
  #           #         {
  #           #           "uuid": "bd690296-8253-4d62-9fa8-41b255f55696",
  #           #           "name": "danny"
  #           #         },
  #           #         {
  #           #           "uuid": "ef84e37f-5abe-4992-9d70-85f50c05de3f",
  #           #           "name": "chris"
  #           #         }
  #           #       ]
  #           #     '';
  #           #   };
  #           # };
  #           # thing = {
  #           #   enable = true;
  #           #   mrpack = {
  #           #     enable = true;
  #           #     file = mods1;
  #           #   };
  #           #   java = {
  #           #     memory = 8000;
  #           #     # extraArguments = [
  #           #     #   "-XX:+UseG1GC"
  #           #     #   "-XX:+UnlockExperimentalVMOptions"
  #           #     #   "-XX:G1NewSizePercent=20"
  #           #     #   "-XX:G1ReservePercent=20"
  #           #     #   "-XX:MaxGCPauseMillis=50"
  #           #     #   "-XX:G1HeapRegionSize=32M"
  #           #     # ];
  #           #   };
  #           #   serverProperties = {
  #           #     # level-seed = "asdf";
  #           #     # online-mode = true; # Can be set here too!
  #           #     bug-report-link = null;
  #           #   };
  #           #   # servers can be run as systemd user services
  #           #   # service name is set as nixcraft-server-<name>.service
  #           #   service = {
  #           #     enable = true;
  #           #     autoStart = true;
  #           #   };
  #           #   files = {
  #           #     "whitelist.json".text = ''
  #           #       [
  #           #         {
  #           #           "uuid": "bd690296-8253-4d62-9fa8-41b255f55696",
  #           #           "name": "danny"
  #           #         },
  #           #         {
  #           #           "uuid": "ef84e37f-5abe-4992-9d70-85f50c05de3f",
  #           #           "name": "chris"
  #           #         }
  #           #       ]
  #           #     '';
  #           #   };
  #           # };
  #           # Example paper server
  #           # paper-server = {
  #           #   version = "1.21.1";
  #           #   enable = true;
  #           #   paper.enable = true;
  #           #   java.memory = 2000;
  #           #   serverProperties.online-mode = false;
  #           # };
  #           # onepoint5 = {
  #           #   enable = true;
  #           #   version = "1.5.1";
  #           # };
  #           # onepoint8 = {
  #           #   enable = true;
  #           #   version = "1.8";
  #           # };
  #           # onepoint12 = {
  #           #   version = "1.12.1";
  #           #   enable = true;
  #           #   agreeToEula = true;
  #           #   # Old versions fail to start if server poperties is immutable
  #           #   # So copy the file instead
  #           #   files."server.properties".method = lib.mkForce "copy";
  #           #   binEntry.enable = true;
  #           # };
  #           # # Example server with quilt loader
  #           # quilt-server = {
  #           #   enable = true;
  #           #   version = "1.21.1";
  #           #   quiltLoader = {
  #           #     enable = true;
  #           #     version = "0.29.1";
  #           #   };
  #           # };
  #         };
  #       };
  #       client = {
  #         #   # Config to share with all instances
  #         shared = {
  #           # Symlink screenshots dir from all instances
  #           files."screenshots".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Pictures";
  #           # Common account
  #           # account = {
  #           #   username = "";
  #           #   uuid = "2909ee95-d459-40c4-bcbb-65a0cc413110";
  #           #   offline = true;
  #           # };
  #           #     # Game is passed to the gpu (set if you have nvidia gpu)
  #           #     enableNvidiaOffload = true;
  #           #     envVars = {
  #           #       # Fixes bug with nvidia
  #           #       __GL_THREADED_OPTIMIZATIONS = "0";
  #           #     };
  #           #     binEntry.enable = true;
  #         };
  #         # NOTE: has to be declared, not used
  #         instances = {
  #           #     # Example instance with simply-optimized mrpack
  #           # rising-legends = {
  #           #   enable = true;
  #           #   # Add a desktop entry
  #           #   desktopEntry = {
  #           #     enable = true;
  #           #   };
  #           #   mrpack = {
  #           #     enable = true;
  #           #     file = rising-legends;
  #           #   };
  #           # };
  #           # Example bare bones client
  #           # nomods = {
  #           #   enable = true;
  #           #   version = "1.21.1";
  #           # };
  #           #     # Example client whose version is "latest-release"
  #           #     # Supports "latest-snapshot" too
  #           #     latest = {
  #           #       enable = true;
  #           #       version = "latest-release";
  #           #     };
  #           #     # Audio doesn't seem to work in old versions
  #           #     onepoint5 = {
  #           #       enable = true;
  #           #       version = "1.5.1";
  #           #     };
  #           #     onepoint8 = {
  #           #       enable = true;
  #           #       version = "1.8";
  #           #     };
  #           #     onepoint12 = {
  #           #       enable = true;
  #           #       version = "1.12.1";
  #           #     };
  #           #     # Example client with quilt loader
  #           #     quilt-client = {
  #           #       enable = true;
  #           #       version = "1.21.1";
  #           #       quiltLoader = {
  #           #         enable = true;
  #           #         version = "0.29.1";
  #           #       };
  #           #     };
  #           #     # Example client customized for minecraft speedrunning
  #           #     fsg = {
  #           #       enable = true;
  #           #       # this advanced option accepts common arguments that are passed to the client
  #           #       _classSettings = {
  #           #         fullscreen = true;
  #           #         # height = 1080;
  #           #         # width = 1920;
  #           #         uuid = "2909ee95-d459-40c4-bcbb-65a0cc413110";
  #           #         username = "loystonlive";
  #           #       };
  #           #       # version = "1.16.1"; # need not be set (inferred)
  #           #       mrpack = {
  #           #         enable = true;
  #           #         file = pkgs.fetchurl {
  #           #           url = "https://cdn.modrinth.com/data/1uJaMUOm/versions/jIrVgBRv/SpeedrunPack-mc1.16.1-v5.3.0.mrpack";
  #           #           hash = "sha256-uH/fGFrqP2UpyCupyGjzFB87LRldkPkcab3MzjucyPQ=";
  #           #         };
  #           #       };
  #           #       # Set custom world saves
  #           #       saves = {
  #           #         "Practice Map" = pkgs.fetchzip {
  #           #           url = "https://github.com/Dibedy/The-MCSR-Practice-Map/releases/download/1.0.1/MCSR.Practice.v1.0.1.zip";
  #           #           stripRoot = false;
  #           #           hash = "sha256-ukedZCk6T+KyWqEtFNP1soAQSFSSzsbJKB3mU3kTbqA=";
  #           #         };
  #           #       };
  #           #       # place custom files
  #           #       files = {
  #           #         # mods can also be manually set
  #           #         "mods/fsg-mod.jar".source = pkgs.fetchurl {
  #           #           url = "https://cdn.modrinth.com/data/XZOGBIpM/versions/TcTlTNlF/fsg-mod-5.1.0%2BMC1.16.1.jar";
  #           #           hash = "sha256-gQfbJMsp+QEnuz4T7dC1jEVoGRa5dmK4fXO/Ea/iM+A=";
  #           #         };
  #           #         # setting config files
  #           #         "config/mcsr/standardsettings.json".source = ./standardsettings.json;
  #           #         "options.txt" = {
  #           #           source = ./options.txt;
  #           #         };
  #           #       };
  #           #       java = {
  #           #         extraArguments = [
  #           #           "-XX:+UseZGC"
  #           #           "-XX:+AlwaysPreTouch"
  #           #           "-Dgraal.TuneInlinerExploration=1"
  #           #           "-XX:NmethodSweepActivity=1"
  #           #         ];
  #           #         # override java package. This mrpack needs java 17
  #           #         package = pkgs.jdk17;
  #           #         # set memory in MBs
  #           #         maxMemory = 3500;
  #           #         minMemory = 3500;
  #           #       };
  #           #       # waywall can be enabled
  #           #       waywall.enable = true;
  #           #       # Add executable to path
  #           #       binEntry = {
  #           #         enable = true;
  #           #         # Set executable name
  #           #         name = "fsg";
  #           #       };
  #           #       desktopEntry = {
  #           #         enable = true;
  #           #         name = "Nixcraft FSG";
  #           #         extraConfig = {
  #           #           # TODO: fix icons not working
  #           #           # icon = "${inputs.self}/assets/minecraft/dirt.svg";
  #           #           terminal = true;
  #           #         };
  #           #       };
  #           #     };
  #           #     rsg = {
  #           #       enable = true;
  #           #       _classSettings = {
  #           #         fullscreen = true;
  #           #         uuid = "2909ee95-d459-40c4-bcbb-65a0cc413110";
  #           #         username = "loystonlive";
  #           #       };
  #           #       mrpack = {
  #           #         enable = true;
  #           #         file = pkgs.fetchurl {
  #           #           url = "https://cdn.modrinth.com/data/1uJaMUOm/versions/jIrVgBRv/SpeedrunPack-mc1.16.1-v5.3.0.mrpack";
  #           #           hash = "sha256-uH/fGFrqP2UpyCupyGjzFB87LRldkPkcab3MzjucyPQ=";
  #           #         };
  #           #       };
  #           #       # place custom files
  #           #       files = {
  #           #         # setting config files
  #           #         "config/mcsr/standardsettings.json".source = ./standardsettings.json;
  #           #         "options.txt" = {
  #           #           source = ./options.txt;
  #           #         };
  #           #       };
  #           #       java = {
  #           #         extraArguments = [
  #           #           "-XX:+UseZGC"
  #           #           "-XX:+AlwaysPreTouch"
  #           #           "-Dgraal.TuneInlinerExploration=1"
  #           #           "-XX:NmethodSweepActivity=1"
  #           #         ];
  #           #         package = pkgs.jdk17;
  #           #         maxMemory = 4000;
  #           #         minMemory = 4000;
  #           #       };
  #           #       waywall.enable = true;
  #           #       binEntry = {
  #           #         enable = true;
  #           #         name = "rsg";
  #           #       };
  #           #       desktopEntry = {
  #           #         enable = true;
  #           #         name = "Nixcraft RSG";
  #           #         extraConfig = {
  #           #           terminal = true;
  #           #         };
  #           #       };
  #           # };
  #         };
  #       };
  #     };
  #   };
}
# Config showcasing nixcraft's features

