{
  pkgs,
  home-manager,
  config,
  ...
}:
{
  home = {
    packages = with pkgs; [ gedit ];
  };

  xdg = {
    dataFile = {
      "gedit/styles/catppuccin-macchiato.xml" = {
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
    };
  };

  home = {
    activation = {
      "gedit-theme" = home-manager.lib.hm.dag.entryAfter [ "writeBoundary" "installPackages" ] ''
        ${pkgs.glib}/bin/gsettings --schemadir ${pkgs.gedit}/share/gsettings-schemas set org.gnome.gedit.preferences.editor scheme 'catppuccin-${config.catppuccin.flavor}'
      '';
    };
  };
}
