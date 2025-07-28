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
  }
  // (lib.optionalAttrs (config.programs.btop.enable or false) {
    on-click = "xdg-terminal-exec ${config.programs.btop.package or pkgs.btop}/bin/btop";
  });
}
