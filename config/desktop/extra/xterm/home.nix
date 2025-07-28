{ lib, ... }:
{
  xresources = {
    properties = builtins.listToAttrs (
      lib.lists.flatten (
        lib.attrsets.mapAttrsToList
          (
            name: value:
            if ((builtins.match "^XTerm(\\*|\\.).*" name) != null) then
              [
                {
                  inherit name;
                  inherit value;
                }

                {
                  name = "U${name}";
                  inherit value;
                }
              ]
            else
              [
                {
                  inherit name;
                  inherit value;
                }
              ]
          )
          {
            "XTerm.termName" = "xterm-256color";

            "XTerm*locale" = "false";
            "XTerm*utf8" = 1;
            "XTerm*renderFont" = true;
            "XTerm*faceName" = "JetBrainsMono Nerd Font";
            "XTerm*faceSize" = 14;

            "XTerm*loginshell" = true;

            "XTerm*savelines" = 16384;

            "XTerm*charClass" = "33:48,36-47:48,58-59:48,61:48,63-64:48,95:48,126:48";
            "XTerm*on3Clicks" = "regex [[:alpha:]]+://([[:alnum:]!#+,./=?@_~-]|(%[[:xdigit:]][[:xdigit:]]))+";
            "XTerm*translations" =
              "#override Shift <Btn1Up>: exec-formatted(\"xdg-open '%t'\", PRIMARY)  select-start() select-end()";

            "XTerm*ScrollBar" = false;
            "XTerm*ScrollKey" = true;

            "XTerm*fullscreen" = "never";
          }
      )
    );
  };
}
