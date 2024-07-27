{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ zed-editor ];

    file = {
      "./config/zed/settings.json" = { source = ./settings.json; };
      "./config/zed/themes/catppuccin-pink.json" = {
        source = ./catppuccin-pink.json;
      };
    };
  };
}
