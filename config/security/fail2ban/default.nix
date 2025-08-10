{ config, ... }:
{
  services = {
    fail2ban = {
      enable = true;

      maxretry = 5;
      bantime = "1h";
      bantime-increment = {
        enable = true;
        formula = "ban.Time * math.exp(float(ban.Count + 1) * banFactor) / math.exp(1 * banFactor)";
        # multipliers = "1 2 4 8 16 32 64";
        maxtime = "168h";
        overalljails = true;
      };

      banaction =
        if (config.networking.nftables.enable or "") then "nftables-multiport" else "iptables-multiport";
    };
  };
}
