{ pkgs, ... }: {
  environment = {
    sessionVariables = {
      LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:$NIX_LD_LIBRARY_PATH:${
          pkgs.lib.makeLibraryPath (with pkgs; [ stdenv.cc.cc.lib ])
        }";
    };
  };
}
