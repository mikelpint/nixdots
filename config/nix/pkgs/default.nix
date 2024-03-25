{
  nixpkgs = { config = { allowUnfree = true; }; };

  home-manager = { useGlobalPkgs = true; };
}
