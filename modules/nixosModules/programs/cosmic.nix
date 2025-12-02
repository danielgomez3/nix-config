{...}: {
  # Enable the COSMIC login manager
  services.displayManager.cosmic-greeter.enable = true;

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;

  # security issue, enables all windows clipboard access. pragmatic.
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
}
