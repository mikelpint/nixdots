{
  lib,
  fetchFromGitea,
  stdenv,

  wayland,
  drwl,

  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bufpool";
  version = "git";
  commit = "15bfffd87a6f9da0bc551db95c7c2a9a069b3708";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "sewn";
    repo = "drwl";
    rev =
      if finalAttrs.version == "git" then
        (
          assert builtins.hasAttr "commit" finalAttrs;
          finalAttrs.commit
        )
      else
        "v${finalAttrs.version}";
    sha256 = "AvhGE0PGlwtX+wn59kw+9cH3vHa3S+REEOD9IIzHNxU=";
  };

  buildInputs = [ drwl ];

  outputs = [ "out" ];

  postPatch = ''
    substituteInPlace bufpool.h \
        --replace-fail "#include \"drwl.h\"" "#include \"${drwl}/lib/drwl.h\""
  '';

  installPhase = ''
    mkdir -p $out/lib
    mv bufpool.h $out/lib
  '';

  meta = with lib; {
    homepage = "https://codeberg.org/sewn/drwl";
    description = "A tiny header-only library for handling boilerplate with dual wl_buffer caching.";
    longDescription = ''
      A tiny header-only library for handling boilerplate with dual wl_buffer caching; requires `_GNU_SOURCE` on Linux systems.

      ### Usage
      ```c
      BufPool pool;
      DrwBuf *buf = bufpool_getbuf(&pool, shm, width, height);
      drwl_setimage(drwl, buf->image);

      drwl_rect(drwl, 0, 0, width, height, 1, 1);

      drwl_setimage(drwl, NULL);
      wl_surface_attach(surface, buf->wl_buf, 0, 0);

      bufpool_cleanup(&pool);
      drwl_setimage(drwl, NULL);
      drwl_destroy(drwl);
      ```
    '';
    license = licenses.mit;
    maintainers = [ ];
    inherit (wayland.meta) platforms;
  };
})
