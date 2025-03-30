{ pkgs, ... }: {
  environment = {
    systemPackages = with pkgs;
      [
        # nixd # Using Linux, not compatible
      ];
  };
}
