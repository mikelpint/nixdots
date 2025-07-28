{
  pkgs,
  osConfig,
  config,
  lib,
  user,
  ...
}:
let
  findPkg =
    pkg:
    let
      p = lib.getName pkg;
    in
    x: (if lib.attrsets.isDerivation x then lib.getName x else null) == p;

  has-godot =
    let
      find = findPkg pkgs.godot;
    in
    builtins.any find config.home.packages || builtins.any find osConfig.environment.systemPackages;

  has-godot-mono =
    let
      find = findPkg pkgs.godot-mono;
    in
    builtins.any find config.home.packages || builtins.any find osConfig.environment.systemPackages;
in
{
  imports = lib.optional (false && has-godot-mono) ../../langs/csharp/home.nix;

  home = {
    packages =
      with pkgs;
      with godotPackages;
      [
        godot
        export-template

        # godot-mono
        # export-template-mono
      ];
  };

  xdg =
    let
      catppuccin = {
        inherit
          (config.catppuccin or {
            enable = false;
            flavor = "mocha";
          }
          )
          enable
          flavor
          ;

        flavorTitle =
          if catppuccin.flavor == "frappe" then
            "Frappé"
          else if catppuccin.flavor == "latte" then
            "Latte"
          else if catppuccin.flavor == "macchiato" then
            "Macchiato"
          else
            "Mocha";
      };
    in
    {
      dataFile =
        (
          let
            source =
              let
                find =
                  let
                    export-template = lib.getName pkgs.godotPackages.export-template;
                  in
                  x: (lib.getName x) == export-template;
              in
              lib.lists.findFirst find (lib.lists.findFirst find null
                osConfig.environment.systemPackages
              ) config.home.packages;
          in
          lib.mkIf (source != null) {
            "godot/export_templates/${builtins.replaceStrings [ "-" ] [ "." ] (lib.getVersion source)}" = {
              inherit source;
            };
          }
        )
        // (
          let
            source =
              let
                find =
                  let
                    export-template-mono = lib.getName pkgs.godotPackages.export-template-mono;
                  in
                  x: (if lib.attrsets.isDerivation x then lib.getName x else null) == export-template-mono;
              in
              lib.lists.findFirst find (lib.lists.findFirst find null
                osConfig.environment.systemPackages
              ) config.home.packages;
          in
          lib.mkIf (source != null) {
            "godot/export_templates/${builtins.replaceStrings [ "-" ] [ "." ] (lib.getVersion source)}" = {
              inherit source;
            };
          }
        );

      configFile = lib.mkIf (has-godot || has-godot-mono) (
        {
          "godot/editor_settings-${
            builtins.elemAt (builtins.match "^([0-9].[0-9]).*$" (
              lib.getVersion (
                let
                  find = findPkg pkgs.godot;
                in
                lib.lists.findFirst find (lib.lists.findFirst find null
                  osConfig.environment.systemPackages
                ) config.home.packages
              )
            )) 0
          }.tres" =
            {
              text = ''
                [gd_resource type="EditorSettings" load_steps=2 format=3]

                [sub_resource type="InputEventKey" id="InputEventKey_djrp8"]
                keycode = 4194326

                [resource]
                interface/editor/font_hinting = 2
                interface/editor/main/main_font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf"
                interface/editor/main/main_font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Bold.ttf"
                interface/editor/main/main_font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFontMono-Regular.ttf"

                ${lib.optionalString catppuccin.enable (
                  with catppuccin;
                  let
                    color =
                      color:
                      let
                        matches = builtins.match "^#?([0-9a-fA-F][0-9a-fA-F])([0-9a-fA-F][0-9a-fA-F])([0-9a-fA-F][0-9a-fA-F])([0-9a-fA-F][0-9a-fA-F])?$" color;
                        dec = hex: builtins.toString ((lib.fromHexString hex) / 255.0);
                      in
                      "Color(${lib.lists.foldl (list: hex: "${list}${dec hex}, ") "" (lib.lists.sublist 0 3 matches)}${
                        dec (if (builtins.length matches) == 4 then "ff" else builtins.elemAt matches 3)
                      })";
                  in
                  ''
                    interface/theme/preset = "Custom"

                    interface/theme/base_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#eff1f5"
                        else if catppuccin.flavor == "latte" then
                          "#303446"
                        else if catppuccin.flavor == "macchiato" then
                          "#24273a"
                        else
                          "#1e1e2e"
                      )
                    }
                    interface/theme/accent_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#8839ef"
                        else if catppuccin.flavor == "latte" then
                          "#ca9ee6"
                        else if catppuccin.flavor == "macchiato" then
                          "#c6a0f6"
                        else
                          "#cba6f7"
                      )
                    }

                    interface/theme/contrast = ${builtins.toString (if flavor == "latte" then 0.06 else 0.2)}
                    interface/theme/icon_saturation = ${builtins.toString (if flavor == "latte" then 1.0 else 0.6)}

                    text_editor/theme/color_theme = "Catppuccin ${flavorTitle}"

                    text_editor/theme/highlighting/symbol_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#99d1db"
                        else if catppuccin.flavor == "latte" then
                          "#04a5e5"
                        else if catppuccin.flavor == "macchiato" then
                          "#91d7e3"
                        else
                          "#89dceb"
                      )
                    }
                    text_editor/theme/highlighting/keyword_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#ca9ee6"
                        else if catppuccin.flavor == "latte" then
                          "#8839ef"
                        else if catppuccin.flavor == "macchiato" then
                          "#c6a0f6"
                        else
                          "#cba6f7"
                      )
                    }
                    text_editor/theme/highlighting/control_flow_keyword_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#ca9ee6"
                        else if catppuccin.flavor == "latte" then
                          "#8839ef"
                        else if catppuccin.flavor == "macchiato" then
                          "#c6a0f6"
                        else
                          "#cba6f7"
                      )
                    }
                    text_editor/theme/highlighting/base_type_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#e5c890"
                        else if catppuccin.flavor == "latte" then
                          "#df8e1d"
                        else if catppuccin.flavor == "macchiato" then
                          "#eed49f"
                        else
                          "#f9e2af"
                      )
                    }
                    text_editor/theme/highlighting/engine_type_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#e5c890"
                        else if catppuccin.flavor == "latte" then
                          "#df8e1d"
                        else if catppuccin.flavor == "macchiato" then
                          "#eed49f"
                        else
                          "#f9e2af"
                      )
                    }
                    text_editor/theme/highlighting/user_type_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#e5c890"
                        else if catppuccin.flavor == "latte" then
                          "#df8e1d"
                        else if catppuccin.flavor == "macchiato" then
                          "#eed49f"
                        else
                          "#f9e2af"
                      )
                    }
                    text_editor/theme/highlighting/comment_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#737994"
                        else if catppuccin.flavor == "latte" then
                          "#9ca0b0"
                        else if catppuccin.flavor == "macchiato" then
                          "#6e738d"
                        else
                          "#6c7086"
                      )
                    }
                    text_editor/theme/highlighting/string_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#a6d189"
                        else if catppuccin.flavor == "latte" then
                          "#40a02b"
                        else if catppuccin.flavor == "macchiato" then
                          "#a6da95"
                        else
                          "#a6e3a1"
                      )
                    }
                    text_editor/theme/highlighting/background_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#303446"
                        else if catppuccin.flavor == "latte" then
                          "#eff1f5"
                        else if catppuccin.flavor == "macchiato" then
                          "#24273a"
                        else
                          "#1e1e2e"
                      )
                    }
                    text_editor/theme/highlighting/completion_background_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#292c3c"
                        else if catppuccin.flavor == "latte" then
                          "#e6e9ef"
                        else if catppuccin.flavor == "macchiato" then
                          "#1e2030"
                        else
                          "#181825"
                      )
                    }
                    text_editor/theme/highlighting/completion_selected_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#414559"
                        else if catppuccin.flavor == "latte" then
                          "#ccd0da"
                        else if catppuccin.flavor == "macchiato" then
                          "#363a4f"
                        else
                          "#313244"
                      )
                    }
                    text_editor/theme/highlighting/completion_existing_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#ca9ee621"
                        else if catppuccin.flavor == "latte" then
                          "#8839ef21"
                        else if catppuccin.flavor == "macchiato" then
                          "#c6a0f621"
                        else
                          "#cba6f721"
                      )
                    }
                    text_editor/theme/highlighting/completion_scroll_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#414559"
                        else if catppuccin.flavor == "latte" then
                          "#ccd0da"
                        else if catppuccin.flavor == "macchiato" then
                          "#363a4f"
                        else
                          "#313244"
                      )
                    }
                    text_editor/theme/highlighting/completion_scroll_hovered_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#51576d"
                        else if catppuccin.flavor == "latte" then
                          "#bcc0cc"
                        else if catppuccin.flavor == "macchiato" then
                          "#494d64"
                        else
                          "#45475a"
                      )
                    }
                    text_editor/theme/highlighting/completion_font_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#c6d0f5"
                        else if catppuccin.flavor == "latte" then
                          "#4c4f69"
                        else if catppuccin.flavor == "macchiato" then
                          "#cad3f5"
                        else
                          "#cdd6f4"
                      )
                    }
                    text_editor/theme/highlighting/text_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#c6d0f5"
                        else if catppuccin.flavor == "latte" then
                          "#4c4f69"
                        else if catppuccin.flavor == "macchiato" then
                          "#cad3f5"
                        else
                          "#cdd6f4"
                      )
                    }
                    text_editor/theme/highlighting/line_number_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#838ba7"
                        else if catppuccin.flavor == "latte" then
                          "#8c8fa1"
                        else if catppuccin.flavor == "macchiato" then
                          "#8087a2"
                        else
                          "#7f849c"
                      )
                    }
                    text_editor/theme/highlighting/safe_line_number_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#a6d189"
                        else if catppuccin.flavor == "latte" then
                          "#40a02b"
                        else if catppuccin.flavor == "macchiato" then
                          "#a6da95"
                        else
                          "#a6e3a1"
                      )
                    }
                    text_editor/theme/highlighting/caret_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#f2d5cf"
                        else if catppuccin.flavor == "latte" then
                          "#dc8a78"
                        else if catppuccin.flavor == "macchiato" then
                          "#f4dbd6"
                        else
                          "#f5e0dc"
                      )
                    }
                    text_editor/theme/highlighting/caret_background_color = ${color "#000000"}
                    text_editor/theme/highlighting/text_selected_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#c6d0f5"
                        else if catppuccin.flavor == "latte" then
                          "#4c4f69"
                        else if catppuccin.flavor == "macchiato" then
                          "#cad3f5"
                        else
                          "#cdd6f4"
                      )
                    }
                    text_editor/theme/highlighting/selection_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#626880"
                        else if catppuccin.flavor == "latte" then
                          "#acb0be"
                        else if catppuccin.flavor == "macchiato" then
                          "#5b6078"
                        else
                          "#585b70"
                      )
                    }
                    text_editor/theme/highlighting/brace_mismatch_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#e78284"
                        else if catppuccin.flavor == "latte" then
                          "#d20f39"
                        else if catppuccin.flavor == "macchiato" then
                          "#ed8796"
                        else
                          "#f38ba8"
                      )
                    }
                    text_editor/theme/highlighting/current_line_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#c6d0f510"
                        else if catppuccin.flavor == "latte" then
                          "#4c4f6910"
                        else if catppuccin.flavor == "macchiato" then
                          "#cad3f510"
                        else
                          "#cdd6f410"
                      )
                    }
                    text_editor/theme/highlighting/line_length_guideline_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#414559"
                        else if catppuccin.flavor == "latte" then
                          "#ccd0da"
                        else if catppuccin.flavor == "macchiato" then
                          "#363a4f"
                        else
                          "#313244"
                      )
                    }
                    text_editor/theme/highlighting/word_highlighted_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#626880"
                        else if catppuccin.flavor == "latte" then
                          "#acb0be"
                        else if catppuccin.flavor == "macchiato" then
                          "#5b6078"
                        else
                          "#585b70"
                      )
                    }
                    text_editor/theme/highlighting/number_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#ef9f76"
                        else if catppuccin.flavor == "latte" then
                          "#fe640b"
                        else if catppuccin.flavor == "macchiato" then
                          "#f5a97f"
                        else
                          "#fab387"
                      )
                    }
                    text_editor/theme/highlighting/function_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#8caaee"
                        else if catppuccin.flavor == "latte" then
                          "#1e66f5"
                        else if catppuccin.flavor == "macchiato" then
                          "#8aadf4"
                        else
                          "#89b4fa"
                      )
                    }
                    text_editor/theme/highlighting/member_variable_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#babbf1"
                        else if catppuccin.flavor == "latte" then
                          "#7287fd"
                        else if catppuccin.flavor == "macchiato" then
                          "#b7bdf8"
                        else
                          "#b4befe"
                      )
                    }
                    text_editor/theme/highlighting/mark_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#e7828438"
                        else if catppuccin.flavor == "latte" then
                          "#d20f3938"
                        else if catppuccin.flavor == "macchiato" then
                          "#ed879638"
                        else
                          "#f38ba838"
                      )
                    }
                    text_editor/theme/highlighting/bookmark_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#8caaee"
                        else if catppuccin.flavor == "latte" then
                          "#1e66f5"
                        else if catppuccin.flavor == "macchiato" then
                          "#8aadf4"
                        else
                          "#89b4fa"
                      )
                    }
                    text_editor/theme/highlighting/breakpoint_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#e78284"
                        else if catppuccin.flavor == "latte" then
                          "#d20f39"
                        else if catppuccin.flavor == "macchiato" then
                          "#ed8796"
                        else
                          "#f38ba8"
                      )
                    }
                    text_editor/theme/highlighting/executing_line_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#e5c890"
                        else if catppuccin.flavor == "latte" then
                          "#df8e1d"
                        else if catppuccin.flavor == "macchiato" then
                          "#eed49f"
                        else
                          "#f9e2af"
                      )
                    }
                    text_editor/theme/highlighting/code_folding_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#838ba7"
                        else if catppuccin.flavor == "latte" then
                          "#8c8fa1"
                        else if catppuccin.flavor == "macchiato" then
                          "#8087a2"
                        else
                          "#7f849c"
                      )
                    }
                    text_editor/theme/highlighting/search_result_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#626880"
                        else if catppuccin.flavor == "latte" then
                          "#acb0be"
                        else if catppuccin.flavor == "macchiato" then
                          "#5b6078"
                        else
                          "#585b70"
                      )
                    }
                    text_editor/theme/highlighting/search_result_border_color = ${color "#00000000"}
                    text_editor/theme/highlighting/gdscript/function_definition_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#8caaee"
                        else if catppuccin.flavor == "latte" then
                          "#1e66f5"
                        else if catppuccin.flavor == "macchiato" then
                          "#8aadf4"
                        else
                          "#89b4fa"
                      )
                    }
                    text_editor/theme/highlighting/gdscript/global_function_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#e78284"
                        else if catppuccin.flavor == "latte" then
                          "#d20f39"
                        else if catppuccin.flavor == "macchiato" then
                          "#ed8796"
                        else
                          "#f38ba8"
                      )
                    }
                    text_editor/theme/highlighting/gdscript/node_path_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#81c8be"
                        else if catppuccin.flavor == "latte" then
                          "#179299"
                        else if catppuccin.flavor == "macchiato" then
                          "#8bd5ca"
                        else
                          "#94e2d5"
                      )
                    }
                    text_editor/theme/highlighting/gdscript/node_reference_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#81c8be"
                        else if catppuccin.flavor == "latte" then
                          "#179299"
                        else if catppuccin.flavor == "macchiato" then
                          "#8bd5ca"
                        else
                          "#94e2d5"
                      )
                    }
                    text_editor/theme/highlighting/gdscript/annotation_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#ef9f76"
                        else if catppuccin.flavor == "latte" then
                          "#fe640b"
                        else if catppuccin.flavor == "macchiato" then
                          "#f5a97f"
                        else
                          "#fab387"
                      )
                    }
                    text_editor/theme/highlighting/gdscript/string_name_color = ${
                      color (
                        if catppuccin.flavor == "frappe" then
                          "#c6d0f5"
                        else if catppuccin.flavor == "latte" then
                          "#4c4f69"
                        else if catppuccin.flavor == "macchiato" then
                          "#cad3f5"
                        else
                          "#cdd6f4"
                      )
                    }
                  ''
                )}

                editors/3d_gizmos/gizmo_settings/bone_axis_length = 0.1

                export/android/debug_keystore = "/home/${user}/.local/share/godot/keystores/debug.keystore"
                export/android/debug_keystore_pass = "android"
                export/android/java_sdk_path = ""
                export/android/android_sdk_path = "/home/${user}/Android/Sdk"

                export/macos/rcodesign = ""

                export/web/http_port = 8080
                export/web/tls_key = "${
                  lib.optionalString (builtins.hasAttr "mikelpint.com.key" (
                    config.age.secrets or { }
                  )) config.age.secrets."mikelpint.com.key".path
                }"
                export/web/tls_certificate = "${
                  lib.optionalString (builtins.hasAttr "mikelpint.com.crt" (
                    config.age.secrets or { }
                  )) config.age.secrets."mikelpint.com.crt".path
                }"

                export/windows/rcedit = ""
                export/windows/osslsigncode = ""
                export/windows/wine = ""

                _editor_settings_advanced_mode = true

                _project_settings_advanced_mode = false

                _export_template_download_directory = ""

                _default_feature_profile = ""

                _script_setup_templates_dictionary = {}

                _use_favorites_root_selection = false

                _script_setup_use_script_templates = false

                shortcuts = [{
                "name": "spatial_editor/viewport_zoom_modifier_1",
                "shortcuts": [SubResource("InputEventKey_djrp8")]
                }, {
                "name": "spatial_editor/viewport_zoom_modifier_2",
                "shortcuts": []
                }]
              '';
            };
        }
        // (

          lib.optionalAttrs catppuccin.enable (
            let
              filename = "Catppuccin ${catppuccin.flavorTitle}.tet";
            in
            {
              "godot/text_editor_themes/${filename}" = {
                source = "${
                  pkgs.fetchFromGitHub {
                    owner = "catppuccin";
                    repo = "godot";
                    rev = "d8b72b679078f0103a5e5c1ef793c1d698a563b1";
                    sha256 = "Og69rMEsygVYpWVGvJGsCydQzRC9BXBQxyrJ4kfdUEo=";
                  }
                }/themes/${filename}";
              };
            }
          )
        )
      );
    };

  programs = {
    zed-editor = {
      extensions = lib.optional has-godot "gdscript";
    };
  };
}
