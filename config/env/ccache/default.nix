{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs = {
    ccache = lib.mkDefault {
      enable = true;

      cacheDir = "/var/cache/ccache";

      owner = "root";
      group = "nixbld";

      packageNames = [ ];
    };
  };

  nix = {
    settings = {
      extra-sandbox-paths = lib.optional (config.programs.ccache.enable or false) (
        config.programs.ccache.cacheDir or "/var/cache/ccache"
      );
    };
  };

  # https://wiki.nixos.org/wiki/CCache
  # https://github.com/NixOS/nixpkgs/blob/e24c4f8cbbf4b03999c0b1d4d48b148e75ace1b5/pkgs/top-level/all-packages.nix#L17670-L17672
  nixpkgs = {
    overlays = [
      (_self: super: {
        ccacheWrapper = super.ccacheWrapper.override {
          extraConfig = ''
            export CCACHE_COMPRESS=1
            export CCACHE_DIR=${config.programs.ccache.cacheDir or "/var/cache/ccache"}
            export CCACHE_UMASK=007

            if [ ! -d "$CCACHE_DIR" ]
            then
                if [[ -z $(sudo -n true) ]]
                then
                    sudo mkdir -m0770 "$CCACHE_DIR"
                    sudo chown ${config.programs.ccache.owner or "root"}:${
                      config.programs.ccache.group or "nixbld"
                    } "$CCACHE_DIR"
                else
                    echo "Directory '$CCACHE_DIR' does not exist"
                    echo "Please create it with:"
                    echo "  sudo mkdir -m0770 '$CCACHE_DIR'"
                    echo "  sudo chown ${config.programs.ccache.owner or "root"}:${
                      config.programs.ccache.group or "nixbld"
                    } '$CCACHE_DIR'"

                    exit 1
                fi
            fi
            if [ ! -w "$CCACHE_DIR" ]
            then
                echo "Directory '$CCACHE_DIR' is not accessible for user $(whoami)"
                echo "Please verify its access permissions"

                exit 1
            fi
          '';
        };
      })
    ];
  };

  environment = {
    systemPackages = [
      (pkgs.writeTextFile {
        name = "ccache.conf";
        destination = "/var/cache/ccache/ccache.conf";

        text =
          if (config.programs.ccache.enable or false) && false then
            ''
              sloppiness = random_seed
            ''
          else
            "";
      })
    ];
  };
}
