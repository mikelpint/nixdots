{
  pkgs,
  lib,
  config,
  user,
  ...
}:
{
  environment = {
    systemPackages = with pkgs; [
      curlFull
      wget
      wget2
    ];
  };

  programs = {
    firejail = {
      wrappedBinaries =
        let
          findImpl =
            pkg: pred:
            lib.lists.findFirst (
              let
                name = lib.getName pkg;
              in
              x: (if lib.attrsets.isDerivation x then lib.getName x else null) == name && pred x
            );
          find =
            pkg:
            findImpl pkg (findImpl pkg null
              config.environment.systemPackages
            ) config.home-manager.users.${user}.home.packages;
        in
        {
          curl =
            let
              curl = lib.lists.findFirst (pkg: (find null pkg) != null) (
                with pkgs;
                [
                  curlFull
                  curlHttp3
                  curlWithGnuTls
                  curl
                  curlMinimal
                ]
              );
            in
            lib.mkIf (curl != null) {
              executable = "${lib.getBin curl}/bin/curl";
              profile = "${pkgs.firejail}/etc/firejail/curl.profile";
            };

          wget =
            let
              wget = find null pkgs.wget;
            in
            lib.mkIf (wget != null) {
              executable = "${lib.getBin wget}/bin/wget";
              profile = "${pkgs.firejail}/etc/firejail/wget.profile";
            };

          wget2 =
            let
              wget2 = find null pkgs.wget2;
            in
            lib.mkIf (wget2 != null) {
              executable = "${lib.getBin wget2}/bin/wget2";
              profile = "${pkgs.firejail}/etc/firejail/wget2.profile";
            };
        };
    };
  };
}
