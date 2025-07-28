{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
{
  "disk" = {
    interval = 60;

    path = "/";

    states = {
      warning = 70;
      critical = 90;
    };

    format = " {percentage_used}%";
  }
  // (
    let
      find = lib.lists.findFirst (
        let
          ncdu = lib.getName pkgs.ncdu;
          ncdu_1 = lib.getName pkgs.ncdu;
          ncdu_2 = lib.getName pkgs.ncdu_2;
        in
        x:
        let
          name = if lib.attrsets.isDerivation x then lib.getName x else null;
        in
        name == ncdu || name == ncdu_1 || name == ncdu_2
      );
      ncdu = find (find null osConfig.environment.systemPackages) config.home.packages;
    in
    lib.optionalAttrs (ncdu != null) {
      on-click = "xdg-terminal-exec ${ncdu}/bin/ncdu / -q -2 -t $(echo -e \"1\\n$(( $(nproc --all) * 3 / 4 ))\" | sort | tail -n 1) --exclude-kernfs --exclude /mnt";
    }
  )
  // (
    let
      find = lib.lists.findFirst (
        let
          gdu = lib.getName pkgs.gdu;
        in
        x: (if lib.attrsets.isDerivation x then lib.getName x else null) == gdu
      );
      gdu = find (find null osConfig.environment.systemPackages) config.home.packages;
    in
    lib.optionalAttrs (gdu != null) {
      on-click = "xdg-terminal-exec ${lib.getBin gdu}/bin/gdu / -m $(echo -e \"1\\n$(( $(nproc) * 3 / 4 ))\" | sort | tail -n 1) -i /proc,/dev,/sys,/run,/mnt -C";
    }
  );
}
