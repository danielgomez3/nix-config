{...}: {
  services.ollama = {
    enable = true;
    loadModels = ["deepseek-r1:70b"];
  };
}
