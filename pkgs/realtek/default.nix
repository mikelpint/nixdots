# https://discourse.nixos.org/t/patching-an-in-tree-linux-kernel-module/22137/2

{ stdenv, lib, kernel }:

let
  modPath = "drivers/net/ethernet/realtek";
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/${modPath}";

in stdenv.mkDerivation rec {
  name = "realtek-${kernel.version}";

  inherit (kernel) src version;

  postPatch = ''
    cd ${modPath}
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "-C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)"
    "modules"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p ${modDestDir}
    find . -name '*.ko' -exec cp --parents '{}' ${modDestDir} \;
    find ${modDestDir} -name '*.ko' -exec xz -f '{}' \;

    runHook postInstall
  '';

  meta = with lib; {
    description = "Realtek ethernet drivers";
    inherit (kernel.meta) license platforms;
  };
}
