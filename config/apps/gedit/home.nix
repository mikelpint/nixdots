{
  pkgs,
  home-manager,
  config,
  lib,
  ...
}:
{
  home = {
    packages = with pkgs; [ gedit ];

    activation =
      let
        gedit = lib.lists.findFirst (
          x:
          let
            gedit = lib.getName pkgs.gedit;
          in
          (if lib.attrsets.isDerivation x then lib.getName x else null) == gedit
        ) null config.home.packages;
      in
      lib.mkIf (gedit != null && (config.catppuccin.enable or false)) {
        "gedit-theme" =
          home-manager.lib.hm.dag.entryAfter [ "writeBoundary" "installPackages" (lib.getName gedit) ]
            ''
              SCHEMADIR="$(${gedit}/share/gsettings-schemas/gedit-$(${gedit}/bin/gedit --version | sed -r 's/gedit - Version (.+)/\1/g')/glib-2.0/schemas)"
              ${pkgs.glib}/bin/gsettings --schemadir $SCHEMADIR set org.gnome.gedit.preferences.editor editor-font 'JetBrainsMono Nerd Font 12'
              ${lib.optionalString (config.catppuccin.enable or false) ''
                ${pkgs.glib}/bin/gsettings --schemadir $SCHEMADIR set org.gnome.gedit.preferences.editor style-scheme-for-light-theme-variant 'catppuccin-${config.catppuccin.flavor}'
                ${pkgs.glib}/bin/gsettings --schemadir $SCHEMADIR set org.gnome.gedit.preferences.editor style-scheme-for-dark-theme-variant 'catppuccin-${config.catppuccin.flavor}'
              ''}
            '';
      };
  };

  xdg = {
    dataFile = lib.mkIf (config.catppuccin.enable or false) {
      # https://github.com/catppuccin/gedit/blob/c118958d28298d80c869f06d4b8a794df9e0c2c5/themes/catppuccin-frappe.xml
      "libgedit-gtksourceview-300/styles/catppuccin-frappe.xml" =
        lib.mkIf (config.catppuccin.flavor == "frappe")
          {
            text = ''
              <?xml version="1.0" encoding="UTF-8"?>
              <style-scheme id="catppuccin-frappe" name="Catppuccin Frappé" kind="dark">
                <description>Soothing pastel theme for Gedit</description>

                <!-- Catppuccin Palette -->
                <color name="frappe_rosewater" value="#f2d5cf"/>
                <color name="frappe_flamingo" value="#eebebe"/>
                <color name="frappe_pink" value="#f4b8e4"/>
                <color name="frappe_mauve" value="#ca9ee6"/>
                <color name="frappe_red" value="#e78284"/>
                <color name="frappe_maroon" value="#ea999c"/>
                <color name="frappe_peach" value="#ef9f76"/>
                <color name="frappe_yellow" value="#e5c890"/>
                <color name="frappe_green" value="#a6d189"/>
                <color name="frappe_teal" value="#81c8be"/>
                <color name="frappe_sky" value="#99d1db"/>
                <color name="frappe_sapphire" value="#85c1dc"/>
                <color name="frappe_blue" value="#8caaee"/>
                <color name="frappe_lavender" value="#babbf1"/>
                <color name="frappe_text" value="#c6d0f5"/>
                <color name="frappe_subtext1" value="#b5bfe2"/>
                <color name="frappe_subtext0" value="#a5adce"/>
                <color name="frappe_overlay2" value="#949cbb"/>
                <color name="frappe_overlay1" value="#838ba7"/>
                <color name="frappe_overlay0" value="#737994"/>
                <color name="frappe_surface2" value="#626880"/>
                <color name="frappe_surface1" value="#51576d"/>
                <color name="frappe_surface0" value="#414559"/>
                <color name="frappe_base" value="#303446"/>
                <color name="frappe_mantle" value="#292c3c"/>
                <color name="frappe_crust" value="#232634"/>

                <!-- Global Settings -->
                <style name="text"                        foreground="frappe_text" background = "frappe_base"/>
                <style name="selection"                   foreground="frappe_text" background="frappe_surface2"/>
                <style name="cursor"                      foreground="frappe_rosewater"/>
                <style name="secondary-cursor"            foreground="frappe_rosewater"/>
                <style name="current-line"                background="frappe_surface0"/>
                <style name="line-numbers"                foreground="frappe_text" background="frappe_crust"/>
                <style name="draw-spaces"                 foreground="frappe_text"/>
                <style name="background-pattern"          background="frappe_base"/>

                <!-- Bracket Matching -->
                <style name="bracket-match"               foreground="frappe_mauve"/>
                <style name="bracket-mismatch"            foreground="frappe_text" background="frappe_peach"/>

                <!-- Right Margin -->
                <style name="right-margin"                foreground="frappe_text" background="frappe_crust"/>

                <!-- Search Matching -->
                <style name="search-match"                foreground="frappe_text" background="frappe_blue"/>

                <!-- Comments -->
                <style name="def:comment"                 foreground="frappe_overlay0"/>
                <style name="def:shebang"                 foreground="frappe_overlay0" bold="true"/>
                <style name="def:doc-comment-element"     italic="true"/>

                <!-- Constants -->
                <style name="def:constant"                foreground="frappe_green"/>
                <style name="def:string"                  foreground="frappe_green"/>
                <style name="def:special-char"            foreground="frappe_lavender"/>
                <style name="def:special-constant"        foreground="frappe_lavender"/>
                <style name="def:floating-point"          foreground="frappe_lavender"/>

                <!-- Identifiers -->
                <style name="def:identifier"              foreground="frappe_blue"/>

                <!-- Statements -->
                <style name="def:statement"               foreground="frappe_sapphire" bold="true"/>

                <!-- Types -->
                <style name="def:type"                    foreground="frappe_maroon" bold="true"/>

                <!-- Markup -->
                <style name="def:emphasis"                italic="true"/>
                <style name="def:strong-emphasis"         foreground="frappe_yellow" bold="true"/>
                <style name="def:inline-code"             foreground="frappe_green"/>
                <style name="def:insertion"               underline="single"/>
                <style name="def:deletion"                strikethrough="true"/>
                <style name="def:link-text"               foreground="frappe_rosewater"/>
                <style name="def:link-symbol"             foreground="frappe_blue" bold="true"/>
                <style name="def:link-destination"        foreground="frappe_blue" italic="true" underline="single"/>
                <style name="def:heading"                 foreground="frappe_teal" bold="true"/>
                <style name="def:thematic-break"          foreground="frappe_green" bold="true"/>
                <style name="def:preformatted-section"    foreground="frappe_green"/>
                <style name="def:list-marker"             foreground="frappe_teal" bold="true"/>

                <!-- Others -->
                <style name="def:preprocessor"            foreground="frappe_teal"/>
                <style name="def:error"                   foreground="frappe_maroon" bold="true"/>
                <style name="def:warning"                 foreground="frappe_peach"/>
                <style name="def:note"                    foreground="frappe_blue" bold="true"/>
                <style name="def:net-address"             italic="true" underline="single"/>
              </style-scheme>
            '';
          };

      # https://github.com/catppuccin/gedit/blob/c118958d28298d80c869f06d4b8a794df9e0c2c5/themes/catppuccin-latte.xml
      "libgedit-gtksourceview-300/styles/catppuccin-latte.xml" = {
        text = ''
          <?xml version="1.0" encoding="UTF-8"?>
          <style-scheme id="catppuccin-latte" name="Catppuccin Latte" kind="light">
            <description>Soothing pastel theme for Gedit</description>

            <!-- Catppuccin Palette -->
            <color name="latte_rosewater" value="#dc8a78"/>
            <color name="latte_flamingo" value="#dd7878"/>
            <color name="latte_pink" value="#ea76cb"/>
            <color name="latte_mauve" value="#8839ef"/>
            <color name="latte_red" value="#d20f39"/>
            <color name="latte_maroon" value="#e64553"/>
            <color name="latte_peach" value="#fe640b"/>
            <color name="latte_yellow" value="#df8e1d"/>
            <color name="latte_green" value="#40a02b"/>
            <color name="latte_teal" value="#179299"/>
            <color name="latte_sky" value="#04a5e5"/>
            <color name="latte_sapphire" value="#209fb5"/>
            <color name="latte_blue" value="#1e66f5"/>
            <color name="latte_lavender" value="#7287fd"/>
            <color name="latte_text" value="#4c4f69"/>
            <color name="latte_subtext1" value="#5c5f77"/>
            <color name="latte_subtext0" value="#6c6f85"/>
            <color name="latte_overlay2" value="#7c7f93"/>
            <color name="latte_overlay1" value="#8c8fa1"/>
            <color name="latte_overlay0" value="#9ca0b0"/>
            <color name="latte_surface2" value="#acb0be"/>
            <color name="latte_surface1" value="#bcc0cc"/>
            <color name="latte_surface0" value="#ccd0da"/>
            <color name="latte_base" value="#eff1f5"/>
            <color name="latte_mantle" value="#e6e9ef"/>
            <color name="latte_crust" value="#dce0e8"/>

            <!-- Global Settings -->
            <style name="text"                        foreground="latte_text" background = "latte_base"/>
            <style name="selection"                   foreground="latte_text" background="latte_surface2"/>
            <style name="cursor"                      foreground="latte_rosewater"/>
            <style name="secondary-cursor"            foreground="latte_rosewater"/>
            <style name="current-line"                background="latte_surface0"/>
            <style name="line-numbers"                foreground="latte_text" background="latte_crust"/>
            <style name="draw-spaces"                 foreground="latte_text"/>
            <style name="background-pattern"          background="latte_base"/>

            <!-- Bracket Matching -->
            <style name="bracket-match"               foreground="latte_mauve"/>
            <style name="bracket-mismatch"            foreground="latte_text" background="latte_peach"/>

            <!-- Right Margin -->
            <style name="right-margin"                foreground="latte_text" background="latte_crust"/>

            <!-- Search Matching -->
            <style name="search-match"                foreground="latte_text" background="latte_blue"/>

            <!-- Comments -->
            <style name="def:comment"                 foreground="latte_overlay0"/>
            <style name="def:shebang"                 foreground="latte_overlay0" bold="true"/>
            <style name="def:doc-comment-element"     italic="true"/>

            <!-- Constants -->
            <style name="def:constant"                foreground="latte_green"/>
            <style name="def:string"                  foreground="latte_green"/>
            <style name="def:special-char"            foreground="latte_lavender"/>
            <style name="def:special-constant"        foreground="latte_lavender"/>
            <style name="def:floating-point"          foreground="latte_lavender"/>

            <!-- Identifiers -->
            <style name="def:identifier"              foreground="latte_blue"/>

            <!-- Statements -->
            <style name="def:statement"               foreground="latte_sapphire" bold="true"/>

            <!-- Types -->
            <style name="def:type"                    foreground="latte_maroon" bold="true"/>

            <!-- Markup -->
            <style name="def:emphasis"                italic="true"/>
            <style name="def:strong-emphasis"         foreground="latte_yellow" bold="true"/>
            <style name="def:inline-code"             foreground="latte_green"/>
            <style name="def:insertion"               underline="single"/>
            <style name="def:deletion"                strikethrough="true"/>
            <style name="def:link-text"               foreground="latte_rosewater"/>
            <style name="def:link-symbol"             foreground="latte_blue" bold="true"/>
            <style name="def:link-destination"        foreground="latte_blue" italic="true" underline="single"/>
            <style name="def:heading"                 foreground="latte_teal" bold="true"/>
            <style name="def:thematic-break"          foreground="latte_green" bold="true"/>
            <style name="def:preformatted-section"    foreground="latte_green"/>
            <style name="def:list-marker"             foreground="latte_teal" bold="true"/>

            <!-- Others -->
            <style name="def:preprocessor"            foreground="latte_teal"/>
            <style name="def:error"                   foreground="latte_maroon" bold="true"/>
            <style name="def:warning"                 foreground="latte_peach"/>
            <style name="def:note"                    foreground="latte_blue" bold="true"/>
            <style name="def:net-address"             italic="true" underline="single"/>
          </style-scheme>
        '';
      };

      # https://github.com/catppuccin/gedit/blob/c118958d28298d80c869f06d4b8a794df9e0c2c5/themes/catppuccin-macchiato.xml
      "libgedit-gtksourceview-300/styles/catppuccin-macchiato.xml" = {
        text = ''
          <?xml version="1.0" encoding="UTF-8"?>
          <style-scheme id="catppuccin-macchiato" name="Catppuccin Macchiato" kind="dark">
            <description>Soothing pastel theme for Gedit</description>

            <!-- Catppuccin Palette -->
            <color name="macchiato_rosewater" value="#f4dbd6"/>
            <color name="macchiato_flamingo" value="#f0c6c6"/>
            <color name="macchiato_pink" value="#f5bde6"/>
            <color name="macchiato_mauve" value="#c6a0f6"/>
            <color name="macchiato_red" value="#ed8796"/>
            <color name="macchiato_maroon" value="#ee99a0"/>
            <color name="macchiato_peach" value="#f5a97f"/>
            <color name="macchiato_yellow" value="#eed49f"/>
            <color name="macchiato_green" value="#a6da95"/>
            <color name="macchiato_teal" value="#8bd5ca"/>
            <color name="macchiato_sky" value="#91d7e3"/>
            <color name="macchiato_sapphire" value="#7dc4e4"/>
            <color name="macchiato_blue" value="#8aadf4"/>
            <color name="macchiato_lavender" value="#b7bdf8"/>
            <color name="macchiato_text" value="#cad3f5"/>
            <color name="macchiato_subtext1" value="#b8c0e0"/>
            <color name="macchiato_subtext0" value="#a5adcb"/>
            <color name="macchiato_overlay2" value="#939ab7"/>
            <color name="macchiato_overlay1" value="#8087a2"/>
            <color name="macchiato_overlay0" value="#6e738d"/>
            <color name="macchiato_surface2" value="#5b6078"/>
            <color name="macchiato_surface1" value="#494d64"/>
            <color name="macchiato_surface0" value="#363a4f"/>
            <color name="macchiato_base" value="#24273a"/>
            <color name="macchiato_mantle" value="#1e2030"/>
            <color name="macchiato_crust" value="#181926"/>

            <!-- Global Settings -->
            <style name="text"                        foreground="macchiato_text" background = "macchiato_base"/>
            <style name="selection"                   foreground="macchiato_text" background="macchiato_surface2"/>
            <style name="cursor"                      foreground="macchiato_rosewater"/>
            <style name="secondary-cursor"            foreground="macchiato_rosewater"/>
            <style name="current-line"                background="macchiato_surface0"/>
            <style name="line-numbers"                foreground="macchiato_text" background="macchiato_crust"/>
            <style name="draw-spaces"                 foreground="macchiato_text"/>
            <style name="background-pattern"          background="macchiato_base"/>

            <!-- Bracket Matching -->
            <style name="bracket-match"               foreground="macchiato_mauve"/>
            <style name="bracket-mismatch"            foreground="macchiato_text" background="macchiato_peach"/>

            <!-- Right Margin -->
            <style name="right-margin"                foreground="macchiato_text" background="macchiato_crust"/>

            <!-- Search Matching -->
            <style name="search-match"                foreground="macchiato_text" background="macchiato_blue"/>

            <!-- Comments -->
            <style name="def:comment"                 foreground="macchiato_overlay0"/>
            <style name="def:shebang"                 foreground="macchiato_overlay0" bold="true"/>
            <style name="def:doc-comment-element"     italic="true"/>

            <!-- Constants -->
            <style name="def:constant"                foreground="macchiato_green"/>
            <style name="def:string"                  foreground="macchiato_green"/>
            <style name="def:special-char"            foreground="macchiato_lavender"/>
            <style name="def:special-constant"        foreground="macchiato_lavender"/>
            <style name="def:floating-point"          foreground="macchiato_lavender"/>

            <!-- Identifiers -->
            <style name="def:identifier"              foreground="macchiato_blue"/>

            <!-- Statements -->
            <style name="def:statement"               foreground="macchiato_sapphire" bold="true"/>

            <!-- Types -->
            <style name="def:type"                    foreground="macchiato_maroon" bold="true"/>

            <!-- Markup -->
            <style name="def:emphasis"                italic="true"/>
            <style name="def:strong-emphasis"         foreground="macchiato_yellow" bold="true"/>
            <style name="def:inline-code"             foreground="macchiato_green"/>
            <style name="def:insertion"               underline="single"/>
            <style name="def:deletion"                strikethrough="true"/>
            <style name="def:link-text"               foreground="macchiato_rosewater"/>
            <style name="def:link-symbol"             foreground="macchiato_blue" bold="true"/>
            <style name="def:link-destination"        foreground="macchiato_blue" italic="true" underline="single"/>
            <style name="def:heading"                 foreground="macchiato_teal" bold="true"/>
            <style name="def:thematic-break"          foreground="macchiato_green" bold="true"/>
            <style name="def:preformatted-section"    foreground="macchiato_green"/>
            <style name="def:list-marker"             foreground="macchiato_teal" bold="true"/>

            <!-- Others -->
            <style name="def:preprocessor"            foreground="macchiato_teal"/>
            <style name="def:error"                   foreground="macchiato_maroon" bold="true"/>
            <style name="def:warning"                 foreground="macchiato_peach"/>
            <style name="def:note"                    foreground="macchiato_blue" bold="true"/>
            <style name="def:net-address"             italic="true" underline="single"/>
          </style-scheme>
        '';
      };

      # https://github.com/catppuccin/gedit/blob/c118958d28298d80c869f06d4b8a794df9e0c2c5/themes/catppuccin-mocha.xml
      "libgedit-gtksourceview-300/styles/catppuccin-mocha.xml" = {
        text = ''
          <?xml version="1.0" encoding="UTF-8"?>
          <style-scheme id="catppuccin-mocha" name="Catppuccin Mocha" kind="dark">
            <description>Soothing pastel theme for Gedit</description>

            <!-- Catppuccin Palette -->
            <color name="mocha_rosewater" value="#f5e0dc"/>
            <color name="mocha_flamingo" value="#f2cdcd"/>
            <color name="mocha_pink" value="#f5c2e7"/>
            <color name="mocha_mauve" value="#cba6f7"/>
            <color name="mocha_red" value="#f38ba8"/>
            <color name="mocha_maroon" value="#eba0ac"/>
            <color name="mocha_peach" value="#fab387"/>
            <color name="mocha_yellow" value="#f9e2af"/>
            <color name="mocha_green" value="#a6e3a1"/>
            <color name="mocha_teal" value="#94e2d5"/>
            <color name="mocha_sky" value="#89dceb"/>
            <color name="mocha_sapphire" value="#74c7ec"/>
            <color name="mocha_blue" value="#89b4fa"/>
            <color name="mocha_lavender" value="#b4befe"/>
            <color name="mocha_text" value="#cdd6f4"/>
            <color name="mocha_subtext1" value="#bac2de"/>
            <color name="mocha_subtext0" value="#a6adc8"/>
            <color name="mocha_overlay2" value="#9399b2"/>
            <color name="mocha_overlay1" value="#7f849c"/>
            <color name="mocha_overlay0" value="#6c7086"/>
            <color name="mocha_surface2" value="#585b70"/>
            <color name="mocha_surface1" value="#45475a"/>
            <color name="mocha_surface0" value="#313244"/>
            <color name="mocha_base" value="#1e1e2e"/>
            <color name="mocha_mantle" value="#181825"/>
            <color name="mocha_crust" value="#11111b"/>

            <!-- Global Settings -->
            <style name="text"                        foreground="mocha_text" background = "mocha_base"/>
            <style name="selection"                   foreground="mocha_text" background="mocha_surface2"/>
            <style name="cursor"                      foreground="mocha_rosewater"/>
            <style name="secondary-cursor"            foreground="mocha_rosewater"/>
            <style name="current-line"                background="mocha_surface0"/>
            <style name="line-numbers"                foreground="mocha_text" background="mocha_crust"/>
            <style name="draw-spaces"                 foreground="mocha_text"/>
            <style name="background-pattern"          background="mocha_base"/>

            <!-- Bracket Matching -->
            <style name="bracket-match"               foreground="mocha_mauve"/>
            <style name="bracket-mismatch"            foreground="mocha_text" background="mocha_peach"/>

            <!-- Right Margin -->
            <style name="right-margin"                foreground="mocha_text" background="mocha_crust"/>

            <!-- Search Matching -->
            <style name="search-match"                foreground="mocha_text" background="mocha_blue"/>

            <!-- Comments -->
            <style name="def:comment"                 foreground="mocha_overlay0"/>
            <style name="def:shebang"                 foreground="mocha_overlay0" bold="true"/>
            <style name="def:doc-comment-element"     italic="true"/>

            <!-- Constants -->
            <style name="def:constant"                foreground="mocha_green"/>
            <style name="def:string"                  foreground="mocha_green"/>
            <style name="def:special-char"            foreground="mocha_lavender"/>
            <style name="def:special-constant"        foreground="mocha_lavender"/>
            <style name="def:floating-point"          foreground="mocha_lavender"/>

            <!-- Identifiers -->
            <style name="def:identifier"              foreground="mocha_blue"/>

            <!-- Statements -->
            <style name="def:statement"               foreground="mocha_sapphire" bold="true"/>

            <!-- Types -->
            <style name="def:type"                    foreground="mocha_maroon" bold="true"/>

            <!-- Markup -->
            <style name="def:emphasis"                italic="true"/>
            <style name="def:strong-emphasis"         foreground="mocha_yellow" bold="true"/>
            <style name="def:inline-code"             foreground="mocha_green"/>
            <style name="def:insertion"               underline="single"/>
            <style name="def:deletion"                strikethrough="true"/>
            <style name="def:link-text"               foreground="mocha_rosewater"/>
            <style name="def:link-symbol"             foreground="mocha_blue" bold="true"/>
            <style name="def:link-destination"        foreground="mocha_blue" italic="true" underline="single"/>
            <style name="def:heading"                 foreground="mocha_teal" bold="true"/>
            <style name="def:thematic-break"          foreground="mocha_green" bold="true"/>
            <style name="def:preformatted-section"    foreground="mocha_green"/>
            <style name="def:list-marker"             foreground="mocha_teal" bold="true"/>

            <!-- Others -->
            <style name="def:preprocessor"            foreground="mocha_teal"/>
            <style name="def:error"                   foreground="mocha_maroon" bold="true"/>
            <style name="def:warning"                 foreground="mocha_peach"/>
            <style name="def:note"                    foreground="mocha_blue" bold="true"/>
            <style name="def:net-address"             italic="true" underline="single"/>
          </style-scheme>
        '';
      };
    };
  };
}
