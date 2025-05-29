# https://wiki.nixos.org/wiki/Ollama
{pkgs, ...}: {
  environment.systemPackages = [pkgs.chatbox];

  services.open-webui = {
    # Default is localhost:8080
    enable = true;
  };
  services.ollama = {
    enable = true;
    loadModels = ["deepseek-r1:70b"];
  };
}
