{
  pkgs,
  config,
  lib,
  user,
  ...
}:
{
  programs = {
    firejail = {
      wrappedBinaries =
        let
          binExists = bin: pkg: builtins.pathExists "${lib.getBin pkg}/bin/${bin}";

          findImpl =
            pkg: pred:
            lib.lists.findFirst (
              let
                name = lib.getName pkg;
              in
              x: (if lib.attrsets.isDerivation x then lib.getName x else null) == name && pred x
            );
          find =
            pkg:
            findImpl pkg (_pkg: true) (findImpl pkg (
              _pkg: true
            ) null config.environment.systemPackages) config.home-manager.users.${user}.home.packages;

          texlive =
            if (config.home-manager.users.${user}.programs.texlive or false) then
              config.home-manager.users.${user}.programs.texlive.package
                or config.home-manager.users.${user}.programs.texlive.package or pkgs.texlive
            else
              find (find (find (find (find (find (find (find (find (find (find pkgs.texlive) pkgs.texliveInfraOnly) pkgs.texliveBookPub) pkgs.texliveConTeXt) pkgs.texliveTeTeX) pkgs.texliveGUST) pkgs.texliveBasic) pkgs.texliveMinimal) pkgs.texliveSmall) pkgs.texliveMedium) pkgs.texliveFull;
        in
        {
          biblatex =
            let
              biblatex = if texlive != null && binExists "biblatex" texlive then texlive else null;
            in
            lib.mkIf (biblatex != null) {
              executable = "${lib.getBin biblatex}/bin/biblatex";
              profile = "${pkgs.firejail}/etc/firejail/bibtex.profile";
            };

          bibtex =
            let
              bibtex = if texlive != null && binExists "bibtex" texlive then texlive else null;
            in
            lib.mkIf (bibtex != null) {
              executable = "${lib.getBin bibtex}/bin/bibtex";
              profile = "${pkgs.firejail}/etc/firejail/bibtex.profile";
            };

          bibtex8 =
            let
              bibtex8 = if texlive != null && binExists "bibtex8" texlive then texlive else null;
            in
            lib.mkIf (bibtex8 != null) {
              executable = "${lib.getBin bibtex8}/bin/bibtex8";
              profile = "${pkgs.firejail}/etc/firejail/bibtex.profile";
            };

          bibtexu =
            let
              bibtexu = if texlive != null && binExists "bibtexu" texlive then texlive else null;
            in
            lib.mkIf (bibtexu != null) {
              executable = "${lib.getBin bibtexu}/bin/bibtexu";
              profile = "${pkgs.firejail}/etc/firejail/bibtex.profile";
            };

          latex =
            let
              latex = if texlive != null && binExists "latex" texlive then texlive else null;
            in
            lib.mkIf (latex != null) {
              executable = "${lib.getBin latex}/bin/latex";
              profile = "${pkgs.firejail}/etc/firejail/latex.profile";
            };

          pdflatex =
            let
              pdflatex = if texlive != null && binExists "pdflatex" texlive then texlive else null;
            in
            lib.mkIf (pdflatex != null) {
              executable = "${lib.getBin pdflatex}/bin/pdflatex";
              profile = "${pkgs.firejail}/etc/firejail/pdflatex.profile";
            };

          pdftex =
            let
              pdftex = if texlive != null && binExists "pdflatex" texlive then texlive else null;
            in
            lib.mkIf (pdftex != null) {
              executable = "${lib.getBin pdftex}/bin/pdftex";
              profile = "${pkgs.firejail}/etc/firejail/pdflatex.profile";
            };

          tex =
            let
              tex = if texlive != null && binExists "tex" texlive then texlive else null;
            in
            lib.mkIf (tex != null) {
              executable = "${lib.getBin tex}/bin/tex";
              profile = "${pkgs.firejail}/etc/firejail/tex.profile";
            };
        };
    };
  };
}
