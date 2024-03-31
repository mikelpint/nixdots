{
  nixpkgs = { config = { allowUnfree = true; }; };

  home-manager = { useGlobalPkgs = false; };
}
