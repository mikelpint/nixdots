{ pkgs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "steam"
          "steam-original"
          "steam-run"
        ];
    };
  };

  programs = {
    steam = {
      enable = true;
      remotePlay = { openFirewall = true; };
      dedicatedServer = { openFirewall = true; };
    };
  };
}
