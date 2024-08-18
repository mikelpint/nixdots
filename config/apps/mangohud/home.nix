{ pkgs, ... }:
let
  background_color = "24273A";
  text_color = "CAD3F5";
  text_outline_color = "181926";
  cpu_color = "ED8796";
  gpu_color = "A6DA95";
  ram_color = "8AADF4";
  vram_color = "C6A0F6";
  engine_color = "B7BDF8";
  media_player_color = "EED49F";

  load_value = "50,90";
  load_color = "${text_color},F5A97F,ED8796";
in
{
  programs = {
    mangohud = {
      enable = true;
      enableSessionWide = true;

      settings = {
        pci_dev = "0000:06:00.0"; # AMD RX 6700 XT

        legacy_layout = false;
        full = false;
        no_display = false;

        position = "top-left";
        round_corners = 5;

        table_columns = 3;
        cellpadding_y = 5.0e-2;

        inherit background_color;
        background_alpha = 0.3;

        font_size = 24;
        font_scale_media_player = 0.75;
        font_file = "${pkgs.nerdfonts}/share/fonts/truetype/NerdFonts/UbuntuMonoNerdFontMono-Regular.ttf";
        inherit text_color;
        text_outline = true;
        inherit text_outline_color;
        text_outline_thickness = 5.0e-2;

        time = true;
        time_no_label = true;
        time_format = "%H:%M:%S";

        media_player = true;
        media_player_name = "spotify";
        media_player_format = "{title} - {artist}";
        inherit media_player_color;

        frame_timing = false;
        frametime = true;

        fps = true;
        fps_limit = 0;

        cpu_text = "CPU";
        inherit cpu_color;
        cpu_mhz = false;
        cpu_stats = true;
        cpu_temp = true;
        cpu_load_change = true;
        core_load_change = true;
        cpu_load_value = load_value;
        cpu_load_color = load_color;

        gpu_text = "GPU";
        inherit gpu_color;
        gpu_stats = true;
        gpu_temp = true;
        gpu_load_change = true;
        gpu_load_value = load_value;
        gpu_load_color = load_color;

        vram = true;
        inherit vram_color;

        ram = true;
        inherit ram_color;

        engine_version = false;
        inherit engine_color;
      };
    };
  };
}
