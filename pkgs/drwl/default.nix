{
  lib,
  fetchFromGitea,
  stdenv,

  wayland,

  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "drwl";
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

  outputs = [ "out" ];

  installPhase = ''
    mkdir -p $out/lib
    mv drwl.h $out/lib
  '';

  meta = with lib; {
    homepage = "https://codeberg.org/sewn/drwl";
    description = "A simple header-only library utilizing fcft and pixman for primitive rendering of text and rectangles";
    longDescription = ''
      A simple header-only library utilizing fcft and pixman for primitive rendering of text and rectangles.
      See the 'example' folder for a rudimentary program to render some text.

      `drwl_destroy()` will destroy any associated `Img` or `Fnt` objects; if the drwl contexts `Img` or `Fnt` is managed by the user, they must be set to `NULL` beforehand by using `drwl_setimage` and `drwl_setfont` respectively.

      ### API
      ```c
      int drwl_init(void);
      void drwl_fini(void);

      Drwl *drwl_create(void);
      void drwl_setfont(Drwl *drwl, Fnt *font);
      void drwl_setscheme(Drwl *drwl, uint32_t *scm);
      void drwl_setimage(Drwl *drwl, Img *image);
      void drwl_destroy(Drwl *drwl);

      Fnt *drwl_font_create(Drwl *drwl, size_t count, const char *names[static count], const char *attributes);
      void drwl_font_destroy(Fnt *font);

      Img *drwl_image_create(Drwl *drwl, unsigned int w, unsigned int h, uint32_t *bits);
      void drwl_rect(Drwl *drwl, int x, int y, unsigned int w, unsigned int h, int filled, int invert);
      int drwl_text(Drwl *drwl, int x, int y, unsigned int w, unsigned int h, unsigned int lpad, const char *text, int invert);
      unsigned int drwl_font_getwidth(Drwl *drwl, const char *text);
      unsigned int drwl_font_getwidth_clamp(Drwl *drwl, const char *text, unsigned int n);
      void drwl_image_destroy(Drwl *drwl);
      ```
    '';
    license = licenses.mit;
    maintainers = [ ];
    inherit (wayland.meta) platforms;
  };
})
