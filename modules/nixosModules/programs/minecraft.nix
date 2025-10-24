{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = [pkgs.prismlauncher];
}
