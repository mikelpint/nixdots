{
  lib,
  config,
  pkgs,
  ...
}:
{
  "memory" = {
    format = " {percentage}%";
    tooltip-format = "{used:0.1f}GiB of {total:0.1f}GiB in use";

    on-click = lib.optional config.programs.btop.enable "xdg-terminal-exec ${
      config.programs.btop.package or pkgs.btop
    }/bin/btop";
  };
}
