{ user, ... }:
{
  imports = [
    ./jack
    ./pipewire
    ./pulseaudio
  ];

  users = {
    users = {
      "${user}" = {
        extraGroups = [ "audio" ];
      };
    };
  };
}
