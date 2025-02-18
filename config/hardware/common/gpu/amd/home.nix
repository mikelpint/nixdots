{ osConfig, pkgs, lib, ... }:
let
  ifamdgpu =
    lib.mkIf (builtins.elem "amdgpu" osConfig.services.xserver.videoDrivers);
in {
  home = ifamdgpu {
    packages = with pkgs;
      [
        (writeShellScriptBin "waybar_gpu_json" ''
          out=$(${pkgs.radeontop}/bin/radeontop -d - -l 1 -b $(echo "$1" | sed -E 's/0000:0(.):00.0/\1/g') | sed 1d)
          use=$(echo "$out" | grep -Po "(?<=vram [0-9.]{1,5}% )[0-9.]*" | sed '/^[[:space:]]*$/d')

          text=$(printf "%.0f" $(echo "$out" | cut -c 32-34 - | sed 's/[^0-9]*//g' | sed '/^[[:space:]]*$/d'))
          tooltip=$(printf "%s (%.0f%%) of %.2fGiB in use" $((( $(echo "$use < 1000" | ${pkgs.bc}/bin/bc -l) )) && echo $(printf "%.0fMiB" $(echo "($use / 1000) * 1024" | ${pkgs.bc}/bin/bc -l)) || echo $(printf "%.2fGiB" $(echo "$use / 1000" | ${pkgs.bc}/bin/bc -l))) $(echo "$out" | grep -Po "(?<=vram )[0-9.]*" | sed '/^[[:space:]]*$/d') $(echo "$(cat /sys/bus/pci/devices/$1/mem_info_vram_total) / (1024 ^ 3)" | ${pkgs.bc}/bin/bc -l))

          printf '{\"text\": "%s", \"tooltip\": "%s"}' "''${text}" "''${tooltip}"
        '')
      ];
  };
}
