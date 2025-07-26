{ user, ... }:
{
  imports = [
    ./amd
    ./nvidia
  ];

  system = {
    userActivationScripts = {
      hyprgpu = {
        text = ''
          if \
            [[ -h "/home/${user}/.config/hypr/card" ]] && \
            [[ $(realpath "/home/${user}/.config/hypr/card") != $(realpath "/dev/dri/by-path/pci-0000:06:00.0-card") ]]
          then
            rm "/home/${user}/.config/hypr/card"
          fi

          if [[ ! -h "/home/${user}/.config/hypr/card" ]]
          then
              ln -s "/dev/dri/by-path/pci-0000:06:00.0-card" "/home/${user}/.config/hypr/card"
          fi

          if \
            [[ -h "/home/${user}/.config/hypr/otherCard" ]] && \
            [[ $(realpath "/home/${user}/.config/hypr/otherCard") != $(realpath "/dev/dri/by-path/pci-0000:01:00.0-card") ]]
          then
            rm "/home/${user}/.config/hypr/otherCard"
          fi

          if [[ ! -h "/home/${user}/.config/hypr/otherCard" ]]
          then
              ln -s "/dev/dri/by-path/pci-0000:01:00.0-card" "/home/${user}/.config/hypr/otherCard"
          fi
        '';
      };
    };
  };
}
