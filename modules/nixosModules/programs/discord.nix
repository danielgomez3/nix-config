{
  config,
  pkgs,
  ...
}: {
  users.users.${config.myVars.username}.packages = with pkgs; [
    legcord
  ];
}
