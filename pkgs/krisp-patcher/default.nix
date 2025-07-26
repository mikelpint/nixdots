# https://wiki.nixos.org/wiki/Discord#Krisp_noise_suppression

{
  fetchurl,
  python3Packages,
  writers,

  ...
}:
writers.writePython3Bin "krisp-patcher"
  {
    libraries = with python3Packages; [
      capstone
      pyelftools
    ];

    flakeIgnore = [
      "E501"
      "F403"
      "F405"
    ];
  }
  (
    builtins.readFile (fetchurl {
      url = "https://pastebin.com/raw/8tQDsMVd";
      sha256 = "sha256-IdXv0MfRG1/1pAAwHLS2+1NESFEz2uXrbSdvU9OvdJ8=";
    })
  )
