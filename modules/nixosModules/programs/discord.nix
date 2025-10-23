{
  config,
  pkgs,
  ...
}: {
  users.users.${config.myVars.username}.packages = with pkgs; [
    discord-ptb
  ];
}
