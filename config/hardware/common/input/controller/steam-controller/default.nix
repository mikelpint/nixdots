{ pkgs, ... }: {
  environment = { systemPackages = with pkgs; [ steamcontroller ]; };
}
