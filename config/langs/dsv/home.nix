{ pkgs, ... }:
{
  programs = {
    zed-editor = {
      extensions = [ "rainbow-csv" ];
    };
  };

  home = {
    packages = with pkgs; [
      psql2csv
      csv2latex
      csv2odf
      csv2md
      csv2svg
      csvq
      xlsx2csv
      json2tsv
    ];
  };
}
