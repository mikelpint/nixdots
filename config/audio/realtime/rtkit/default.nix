{
  security = {
    rtkit = {
      enable = true;
      args = [
        "--our-realtime-priority=29"
        "--max-realtime-priority=28"
      ];
    };
  };
}
