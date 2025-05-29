{...}: {
  # environment.systemPackages = [pkgs.chatbox];
  services.open-webui = {
    enable = true;
  };
  services.ollama = {
    enable = true;
    loadModels = ["deepseek-r1:70b"];
  };
}
