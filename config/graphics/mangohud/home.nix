{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs = {
    mangohud = {
      enable = lib.mkDefault true;
      enableSessionWide = lib.mkDefault false;
      package = pkgs.mangohud;

      settings = {
        legacy_layout = false;
        full = false;
        no_display = false;

        position = "top-left";
        round_corners = 5;

        table_columns = 3;
        cellpadding_y = 5.0e-2;

        background_alpha = 0.3;

        font_size = 24;
        font_scale_media_player = 0.75;
        font_file = "${pkgs.nerd-fonts.ubuntu-mono}/share/fonts/truetype/NerdFonts/UbuntuMono/UbuntuMonoNerdFontMono-Regular.ttf";
        text_outline = true;
        text_outline_thickness = 5.0e-2;

        time = true;
        time_no_label = true;
        time_format = "%H:%M:%S";

        media_player = true;
        media_player_name = "spotify";
        media_player_format = "{title} - {artist}";

        frame_timing = false;
        frametime = true;

        fps = true;
        fps_limit = 0;

        cpu_text = "CPU";
        cpu_mhz = false;
        cpu_stats = true;
        cpu_temp = true;
        cpu_load_change = true;
        core_load_change = true;
        cpu_load_value = "50,90";
        cpu_load_color = config.programs.mangohud.settings.load_color;

        gpu_text = "GPU";
        gpu_stats = true;
        gpu_temp = true;
        gpu_load_change = true;
        gpu_load_value = "50,90";
        gpu_load_color = config.programs.mangohud.settings.load_color;

        vram = true;

        ram = true;

        engine_version = false;
      }
      // (
        let
          inherit
            (config.catppuccin or {
              enable = false;
              flavor = "mocha";
            }
            )
            enable
            flavor
            ;
        in
        lib.mkIf enable (
          (lib.optionalAttrs (flavor == "frappe") {
            background_color = "303446";
            text_color = "C6D0F5";
            text_outline_color = "232634";
            cpu_color = "E78284";
            gpu_color = "A6D189";
            ram_color = "8CAAEE";
            vram_color = "CA9EE6";
            engine_color = "B7BDF8";
            media_player_color = "E5C890";
            load_color = "C6D0F5,F4B8E4,E78284";
          })
          // (lib.optionalAttrs (flavor == "latte") {
            background_color = "EFF1F5";
            text_color = "4C4F69";
            text_outline_color = "DCE0E8";
            cpu_color = "D20F39";
            gpu_color = "40A02B";
            ram_color = "8AADF4";
            vram_color = "8839EF";
            engine_color = "7287FD";
            media_player_color = "DF8E1D";
            load_color = "4C4F69,FE640B,D20F39";
          })
          // (lib.optionalAttrs (flavor == "macchiato") {
            background_color = "24273A";
            text_color = "CAD3F5";
            text_outline_color = "181926";
            cpu_color = "ED8796";
            gpu_color = "A6DA95";
            ram_color = "8AADF4";
            vram_color = "C6A0F6";
            engine_color = "B7BDF8";
            media_player_color = "EED49F";
            load_color = "CAD3F5,F5A97F,ED8796";
          })
          // (lib.optionalAttrs (flavor == "mocha") {
            background_color = "1E1E2E";
            text_color = "CDD6F4";
            text_outline_color = "11111B";
            cpu_color = "F38BA8";
            gpu_color = "A6E3A1";
            ram_color = "89B4FA";
            vram_color = "CBA6F7";
            engine_color = "B4BEFE";
            media_player_color = "F9E2AF";
            load_color = "CDD6F4,FAB387,F38BA8";
          })
        )
      );
    };
  };
}
