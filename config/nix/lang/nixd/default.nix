{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      nixd # Disable when using Lix, not compatible
    ];
  };
}
