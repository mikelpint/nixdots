{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
{
  home = {
    packages = with pkgs; [
      prisma
      prisma-engines
    ];
  }
  // (lib.mkIf false (
    let
      find = lib.lists.findFirst (
        let
          prisma-engines = lib.getName pkgs.prisma-engines;
        in
        x: (if lib.attrsets.isDerivation x then lib.getName x else null) == prisma-engines
      );
      prisma-engines = find (find null osConfig.environment.systemPackages) config.home.packages;
    in
    lib.mkIf (prisma-engines != null) {
      sessionVariables = {
        PRISMA_SCHEMA_ENGINE_BINARY = "${prisma-engines}/bin/schema-engine";
        PRISMA_QUERY_ENGINE_BINARY = "${prisma-engines}/bin/query-engine";
        PRISMA_QUERY_ENGINE_LIBRARY = "${prisma-engines}/lib/libquery_engine.node";
        PRISMA_FMT_BINARY = "${prisma-engines}/bin/prisma-fmt";
      };
    }
  ));

  programs = {
    zed-editor = {
      extensions = lib.optional (builtins.any (
        let
          prisma = lib.getName pkgs.prisma;
        in
        x: (if lib.attrsets.isDerivation x then lib.getName x else null) == prisma
      ) config.home.packages) "prisma";
    };
  };
}
