{
  inputs,
  osConfig,
  config,
  ...
}:
{
  imports = [ inputs.nur.modules.homeManager.default ];

  nixpkgs = {
    config = {
      inherit (osConfig.nixpkgs.config) allowUnfree allowBroken;
    };
  };

  home = {
    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = toString config.nixpkgs.config.allowUnfree;
      NIXPKGS_ALLOW_BROKEN = toString config.nixpkgs.config.allowBroken;
    };
  };
}
