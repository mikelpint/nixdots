_: {
  imports = [
    ../../cli/harlequin
  ];

  programs = {
    zed-editor = {
      extensions = [ "sql" ];
    };
  };
}
