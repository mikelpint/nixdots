{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
{
  imports = [ ../../cli/make/home.nix ];

  home = {
    packages = with pkgs; [
      (lib.hiPrio gcc)
      gdb

      tinycc

      cmake
      gnumake
      gnupatch

      libclang
      (lib.hiPrio clang-tools)
      llvm
      lldb

      valgrind
    ]
    # ++ (lib.optional (builtins.hasAttr ".gdbinit" config.home.file) python3Packages.pygments)
    ;

    file = lib.mkIf false {
      # https://github.com/cyrus-and/gdb-dashboard/blob/616ed5100d3588bb70e3b86737ac0609ce0635cc/.gdbinit
      ".gdbinit" =
        lib.mkIf
          (
            let
              any = builtins.any (
                x: (if lib.attrsets.isDerivation x then lib.getName x else null) == (lib.getName pkgs.gdb)
              );
            in
            any config.home.packages || any osConfig.environment.systemPackages
          )
          {
            source = pkgs.fetchFromGitHub {
              owner = "cyrus-and";
              repo = "gdb-dashboard";
              rev = "616ed5100d3588bb70e3b86737ac0609ce0635cc";
              hash = lib.fakeSha256;
            };
          };
    };
  };

  programs = lib.mkIf false {
    zed-editor =
      let
        find =
          let
            clang-tools = lib.getName pkgs.clang-tools;
          in
          x: (if lib.attrsets.isDerivation x then lib.getName x else null) == clang-tools;
        clang-tools = lib.lists.findFirst find (lib.lists.findFirst find null
          osConfig.environment.systemPackages
        ) config.home.packages;
      in
      lib.mkIf (clang-tools != null) {
        extraPackages = [ clang-tools ];

        userSettings = {
          languages = {
            C = {
              language_servers = [
                "clangd"
                "..."
              ];
            };
          };

          lsp = {
            clangd = {
              binary = {
                path = "${lib.getBin clang-tools}/bin/clangd";
                arguments = [
                  "--background-index"
                  "--compile-commands-dir=build"
                ];
              };
            };
          };
        };
      };
  };
}
