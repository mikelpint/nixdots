{ config, lib, ... }:
{
  "clock" = {
    interval = 1;

    format = "󰥔 {:%T}";
    format-alt = " {:%d/%m/%Y}";

    tooltip = true;
    tooltip-format = "<tt><small>{calendar}</small></tt>";

    calendar = {
      mode = "year";

      mode-mon-col = 3;
      # weeks-pos = "right";

      on-scroll = 1;

      format = lib.mkIf config.catppuccin.enable (
        let
          colors = {
            latte = {
              rosewater = "dc8a78";
              pink = "ea76cb";
              teal = "179299";
              yellow = "df8e1d";
              red = "d20f39";
            };

            frappe = {
              rosewater = "f2d5cf";
              pink = "f4b8e4";
              teal = "81c8be";
              yellow = "e5c890";
              red = "e78284";
            };

            macchiato = {
              rosewater = "f4dbd6";
              pink = "f5bde6";
              teal = "8bd5ca";
              yellow = "eed49f";
              red = "ed8796";
            };

            mocha = {
              rosewater = "f5e0dc";
              pink = "f5c2e7";
              teal = "94e2d5";
              yellow = "f9e2af";
              red = "f38ba8";
            };
          };
          inherit (config.catppuccin) flavor;
        in
        {
          months = "<span color='#${colors."${flavor}".rosewater}'><b>{}</b></span>"; # Rosewater
          days = "<span color='#${colors."${flavor}".rosewater}'><b>{}</b></span>"; # Pink
          weeks = "<span color='#${colors."${flavor}".rosewater}'><b>W{}</b></span>"; # Teal
          weekdays = "<span color='#${colors."${flavor}".rosewater}'><b>{}</b></span>"; # Yellow
          today = "<span color='#${colors."${flavor}".rosewater}'><b>{}</b></span>"; # Red
        }
      );
    };

    actions = {
      on-click-right = "mode";
      on-click-forward = "tz_up";
      on-click-backward = "tz_down";
      on-scroll-up = "shift_down";
      on-scroll-down = "shift_up";
    };
  };
}
