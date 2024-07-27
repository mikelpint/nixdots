{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ fastfetch ];

    file = {
      ".config/fastfetch/config.jsonc" = {
        text = ''
          {
              "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
              "logo": {
                  "type": "builtin",
                  "source": "NixOs"
              },
              "display": {
                  "separator": "",
                  "keyWidth": 6,
                  "color": "white",
                  "percent": {
                      "color": {
                          "green": "white",
                          "yellow": "white",
                          "red": "white"
                      }
                  }
              },
              "modules": [
                  {
                      "type": "board",
                      "key": "╭ "
                  },
                  {
                      "type": "cpu",
                      "key": "├ "
                  },
                  {
                      "type": "memory",
                      "key": "├ "
                  },
                  {
                      "type": "gpu",
                      "key": "├ "
                  },
                  {
                      "type": "disk",
                      "folders": "/",
                      "key": "├ "
                  },
                  {
                      "type": "battery",
                      "key": "├ "
                  },
                  {
                      "type": "poweradapter",
                      "key": "├ ﮣ"
                  },
                  {
                      "type": "display",
                      "key": "╰ 󱡶",
                      "compactType": "scaled-with-refresh-rate"
                  },
                  "break",
                  {
                      "type": "os",
                      "key": "╭ "
                  },
                  {
                      "type": "kernel",
                      "key": "├ "
                  },
                  {
                      "type": "wm",
                      "key": "├ "
                  },
                  {
                      "type": "shell",
                      "key": "├ "
                  },
                  {
                      "type": "terminal",
                      "key": "├ "
                  },
                  {
                      "type": "packages",
                      "key": "├ "
                  },
                  {
                      "type": "uptime",
                      "key": "╰ "
                  },
                  "break",
                  {
                      "type": "colors",
                      "symbol": "circle"
                  }
              ]
          }
        '';
      };
    };
  };
}
