{ pkgs, ... }:
let
  package = "mongodb-ce";
in
{
  imports = [ ./dspace ];

  nixpkgs = {
    overlays = [
      (_self: super: {
        "${package}" = super.${package}.overrideAttrs (old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];

          postInstall =
            (old.postInstall or "")
            + ''
              wrapProgram $out/bin/mongod --set GLIBC_TUNABLES="glibc.pthread.rseq=0"
            '';
        });
      })
    ];
  };

  services = {
    mongodb = {
      enable = true;
      package = pkgs.${package};

      dbpath = "/var/db/mongo";

      user = "mongodb";

      bind_ip = "0.0.0.0";
    };
  };

  boot = {
    kernelParams = [ "transparent_hugepage=always" ];
  };

  systemd = {
    services = {
      enable-transparent-huge-pages = {
        enable = true;
        enableStrictShellChecks = true;

        description = "Enable Transparent Hugepages (THP)";

        unitConfig = {
          defaultDependencies = "no";
        };

        before = [ "mongodb.service" ];
        after = [
          "sysinit.target"
          "local-fs.target"
        ];

        serviceConfig = {
          Type = "oneshot";
          ExecStart = ''
            /bin/sh -c 'echo always | tee /sys/kernel/mm/transparent_hugepage/enabled > /dev/null && echo defer+madvise | tee /sys/kernel/mm/transparent_hugepage/defrag > /dev/null && echo 0 | tee /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none > /dev/null && echo 1 | tee /proc/sys/vm/overcommit_memory > /dev/null'
          '';
        };

        wantedBy = [ "basic.target" ];
      };
    };
  };

  security = {
    pam = {
      loginLimits = [
        {
          domain = "@mongodb";
          type = "soft";
          item = "nproc";
          value = "unlimited";
        }

        {
          domain = "@mongodb";
          type = "hard";
          item = "nproc";
          value = "unlimited";
        }

        {
          domain = "@mongodb";
          type = "soft";
          item = "nofile";
          value = "64000";
        }

        {
          domain = "@mongodb";
          type = "hard";
          item = "nofile";
          value = "64000";
        }
      ];
    };
  };
}
