# https://github.com/NixOS/nixpkgs/blob/fe51d34885f7b5e3e7b59572796e1bcb427eccb1/pkgs/by-name/wl/wlock/package.nix#L48

{
  lib,
  stdenv,
  fetchFromGitea,
  writeText,

  libxcrypt,
  libxkbcommon,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,

  colorname ? { },
  failonclear ? true,

  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wlock";
  version = "git";
  commit = "be975445fa0da7252f8e13b610c518dd472652d0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "sewn";
    repo = "wlock";
    rev =
      if finalAttrs.version == "git" then
        (
          assert builtins.hasAttr "commit" finalAttrs;
          finalAttrs.commit
        )
      else
        "v${finalAttrs.version}";
    sha256 = "Xt7Q51RhFG+UXYukxfORIhc4Df86nxtpDhAhaSmI38A=";
  };

  buildInputs = [
    libxcrypt
    wayland
    wayland-protocols
    libxkbcommon
  ];

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"
    "WAYLAND_SCANNER=${lib.getExe wayland-scanner}"
  ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace Makefile --replace-fail 'chmod 4755' 'chmod 755'

    ${
      let
        boolish =
          value:
          assert (value || !value || value == 1 || value == 0);
          (
            if value then
              1
            else if !value then
              0
            else
              value
          );
      in
      lib.strings.concatLines (
        lib.lists.imap1 (i: patch: "patch -p1 < ${writeText "${builtins.toString i}.patch" patch}") [
          ''
            --- a/config.def.h
            +++ b/config.def.h
            @@ -10,1 +10,1 @@
            -static const int failonclear = 1;
            +static const int failonclear = ${builtins.toString (boolish failonclear)};
          ''

          (
            let
              colors =
                let
                  cn =
                    assert builtins.isAttrs colorname;
                    colorname;
                in
                builtins.listToAttrs (
                  lib.attrsets.mapAttrsToList
                    (name: default: {
                      inherit name;
                      value =
                        let
                          value = cn.${name} or default;
                        in
                        assert (builtins.isList value);
                        assert (builtins.length value == 3);
                        assert (builtins.all (color: builtins.isString color) value);
                        builtins.map (
                          color:
                          let
                            c = lib.strings.toLower color;

                            rgbRegex = "^#([0-9a-f]{6})$";
                            rgb =
                              let
                                matches = builtins.match rgbRegex c;
                              in
                              if matches == null then null else builtins.elemAt matches 0;

                            hexRegex = "^0x([0-9a-f]{8})$";
                            hex =
                              let
                                matches = builtins.match hexRegex c;
                              in
                              if matches == null then null else builtins.elemAt matches 0;
                          in
                          assert (
                            lib.asserts.assertMsg (
                              rgb != null || hex != null
                            ) "${c} does not match \"${rgbRegex}\" nor \"${hexRegex}\"."
                          );
                          if hex != null then "0x${hex}" else "0x${rgb}ff"
                        ) value;
                    })
                    {
                      init = [
                        "0x00000000"
                        "0x00000000"
                        "0x00000000"
                      ];
                      input = [
                        "0x00000000"
                        "0x55555555"
                        "0x77777777"
                      ];
                      input_alt = [
                        "0x00000000"
                        "0x50505050"
                        "0x70707070"
                      ];
                      failed = [
                        "0xcccccccc"
                        "0x33333333"
                        "0x33333333"
                      ];
                    }
                );

              colorList = colors: "{ ${lib.lists.foldl (list: color: "${list}${color}, ") "" colors} }";

              init = colorList colors.init;
              input = colorList colors.input;
              input_alt = colorList colors.input_alt;
              failed = colorList colors.failed;
            in
            ''
              --- a/config.def.h
              +++ b/config.def.h
              @@ -2,6 +2,6 @@
               static Clr colorname[4] = {
              -	[INIT]      = { 0x00000000, 0x00000000, 0x00000000 }, /* after initialization */
              -	[INPUT]     = { 0x00000000, 0x55555555, 0x77777777 }, /* during input */
              -	[INPUT_ALT] = { 0x00000000, 0x50505050, 0x70707070 }, /* during input, second color */
              -	[FAILED]    = { 0xcccccccc, 0x33333333, 0x33333333 }, /* wrong password */
              +	[INIT]      = ${init}, /* after initialization */
              +	[INPUT]     = ${input}, /* during input */
              +	[INPUT_ALT] = ${input_alt}, /* during input, second color */
              +	[FAILED]    = ${failed}, /* wrong password */
               };
            ''
          )
        ]
      )
    }

    cp config.def.h config.h
  '';

  meta = {
    homepage = "https://codeberg.org/sewn/wlock";
    description = "Sessionlocker for Wayland compositors that support the ext-session-lock-v1 protocol";
    longDescription = ''
      wlock is a itsy-bitsy sessionlocker for Wayland compositors that support
      the `ext-session-lock-v1` protocol; an effective port of slock to Wayland, merging
      the alternate color patch to give a sense of feedback.

      Excerpt from the protocol specifying the behavior:
      > The client is responsible for performing authentication and informing the
      > compositor when the session should be unlocked. If the client dies while
      > the session is locked the session remains locked, possibly permanently
      > depending on compositor policy.
    '';
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ fliegendewurst ];
    mainProgram = "wlock";
  };
})
