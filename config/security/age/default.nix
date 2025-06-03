{
  config,
  inputs,
  pkgs,
  lib,
  self,
  user,
  ...
}:
let
  host = lib.strings.removeSuffix user config.networking.hostName;
in
{
  environment = {
    systemPackages = with pkgs; [
      inputs.agenix-rekey.packages."${pkgs.system}".default
      age
      rage
    ];
  };

  age = {
    # identityPaths = lib.mkDefault [ "/home/${user}/.ssh/${host}" ];
    identityPaths = lib.mkDefault [ "/srv/ssh/${host}" ];

    rekey = {
      hostPubkey = lib.mkDefault (builtins.readFile ../../../hosts/${host}/host.pub);
      masterIdentities = lib.mkDefault config.age.identityPaths;

      storageMode = "local";
      localStorageDir = lib.mkDefault "${self}/secrets/rekeyed/${host}";
    };
  };

  fileSystems =
    let
      paths = builtins.filter (i: builtins.match "^\/nix(\/.*)?" i == null) (
        lib.lists.flatten (
          builtins.map
            (
              i:
              let
                comps = lib.strings.splitString "/" i;
                limit = lib.lists.findFirstIndex (comp: comp == ".ssh" || comp == "ssh") (
                  (builtins.length comps) - 1
                ) comps;
                filtered = lib.lists.ifilter0 (idx: _comp: idx < limit) comps;
              in
              builtins.map (path: lib.concatStringsSep "/" ([ (builtins.head filtered) ] ++ path)) (
                builtins.tail (
                  lib.foldl' (acc: x: acc ++ [ ((lib.last acc) ++ [ x ]) ]) [ [ ] ] (builtins.tail filtered)
                )
              )
            )
            (
              builtins.filter (i: builtins.match "^\/.*" i != null) (
                builtins.map (i: builtins.toString (if builtins.isAttrs i then i.identity else i)) (
                  (config.age.identityPaths or [ ]) ++ (config.age.rekey.masterIdentities or [ ])
                )
              )
            )
        )
      );
    in
    {
      "/nix" = {
        depends = [
          "/run"
          "/tmp"
        ] ++ paths;
      };
    }
    // (builtins.listToAttrs (
      builtins.map (name: {
        inherit name;
        value = {
          neededForBoot = true;
        };
      }) paths
    ));
}
