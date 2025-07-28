{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../../../cli/btop/home.nix
    ../../../../rice/fastfetch/home.nix
  ];

  "cpu" = {
    format = " {usage}%";
    tooltip = false;

    interval = 5;
    states = {
      warning = 50;
      critical = 80;
    };
  }
  // (lib.optionalAttrs (config.programs.btop.enable or false) {
    on-click = "xdg-terminal-exec ${lib.getBin (config.programs.btop.package or pkgs.btop)}/bin/btop";
  })
  // (lib.optionalAttrs (config.programs.fastfetch.enable or false) {
    on-click-right = "xdg-terminal-exec ${
      lib.getBin (config.programs.fastfetch.package or pkgs.fastfetch)
    }/bin/fastfetch";
  });
}
