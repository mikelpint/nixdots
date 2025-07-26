_: {
  imports = [
    ./nil/home.nix
    ./nixd/home.nix
  ];

  programs = {
    zed-editor = {
      extensions = [ "nix" ];

      userSettings = {
        languages = {
          Nix = {
            formatter = {
              external = {
                command = "nix";
                arguments = [
                  "fmt"
                  "--quiet"
                  "{buffer_path}"
                ];
              };
            };
          };
        };
      };
    };
  };
}
