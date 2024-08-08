{ lib, ... }:

let
  group = "wheel";
  actions = [ "*" ];
in {
  security = {
    polkit = {
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if ((${
            (if builtins.elem "*" actions then
              "true"
            else
              (lib.lists.foldl
                (action: logic: logic + " || action.id == \"$action\"") "false"
                (actions)))
          }) && subject.isInGroup("${group}")) {
            return polkit.Result.YES;
          }
        });
      '';
    };
  };
}
