{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  boot = {
    kernelModules = [
      "v4l2loopback"
      "video4linux"
    ];
    extraModulePackages =
      lib.optional (builtins.any (x: x == "v4l2loopback") (config.boot.kernelModules or [ ]))
        (
          let
            nixpkgs-small-linux =
              inputs.nixpkgs-small.legacyPackages."${pkgs.system}".linuxKernel.packages."${lib.getName (
                let
                  inherit (config.boot.kernelPackages.kernel) version;
                  matches = builtins.match "^([0-9]+)\\.([0-9]+)(\\.([0-9]+))*$" version;
                in
                "linux_${
                  if matches != null && builtins.length matches >= 2 then
                    "${builtins.elemAt matches 0}_${builtins.elemAt matches 1}"
                  else
                    version
                }"
              )}";
          in
          if
            (
              (lib.getVersion (nixpkgs-small-linux.kernel or { version = null; }))
              == (lib.getVersion config.boot.kernelPackages.kernel)
            )
          then
            nixpkgs-small-linux.v4l2loopback or config.boot.kernelPackages.v4l2loopback
          else
            config.boot.kernelPackages.v4l2loopback
        );
  };
}
