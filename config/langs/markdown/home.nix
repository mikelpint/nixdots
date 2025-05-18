{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      glow

      marksman

      mermaid-cli
      mermaid-filter
    ];
  };
}
