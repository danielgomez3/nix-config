# TODO: add the nixcraft thing with desktop support
{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = [pkgs.prismlauncher];
}
