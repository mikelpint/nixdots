{
  services = {
    journald = {
      extraConfig = ''
        Storage=volatile
        RateLimitInterval=30s
        RateLimitBurst=10000
        RuntimeMaxUse=16M
        SystemMaxUse=16M
      '';
    };
  };
}
