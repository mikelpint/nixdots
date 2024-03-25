{
  environment.systemPackages = [
    (pkgs.discord.override {
      withOpenASAR = false;
      withVencord = true;
    })
    pkgs.xwaylandvideobridge
  ];
}
