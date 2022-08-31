{
  description = "Typesetting for Valentin's Masters Thesis";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils }:
    with flake-utils.lib; eachSystem allSystems (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      tex = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-medium latexmk koma-script babel-english
          physics mathtools amsmath fontspec booktabs siunitx caption biblatex float
          pgfplots microtype fancyvrb csquotes setspace newunicodechar hyperref
          cleveref multirow bbold unicode-math biblatex-phys xpatch beamerposter
          type1cm changepage lualatex-math footmisc wrapfig2 curve2e pict2e wrapfig
          appendixnumberbeamer sidecap;
      };
    in rec {
      packages = {
        watch = pkgs.writeShellScriptBin "watch-latex" ''
                 ${tex}/bin/latexmk
                 while ${pkgs.inotify-tools}/bin/inotifywait --include ".*\.(sty|tex|pgf|pdf)" -e modify -r .; do
                   ${tex}/bin/latexmk
                 done
              '';
        document = pkgs.stdenvNoCC.mkDerivation rec {
          name = "masters-thesis";
          src = self;
          buildInputs = [ pkgs.coreutils tex pkgs.biber];
          phases = ["unpackPhase" "buildPhase" "installPhase"];
          buildPhase = ''
            export PATH="${pkgs.lib.makeBinPath buildInputs}";
            mkdir -p .cache/texmf-var
            env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
              OSFONTDIR=${pkgs.gyre-fonts}/share/fonts \
              latexmk -interaction=nonstopmode \
              ./index.tex
          '';
          installPhase = ''
            mkdir -p $out
            cp output/index.pdf $out/
          '';
        };
      };
      defaultPackage = packages.document;
      devShell = pkgs.mkShellNoCC {
        buildInputs = [packages.watch pkgs.openjdk] ++ packages.document.buildInputs;
        shellHook = ''
          export OSFONTDIR=${pkgs.gyre-fonts}/share/fonts:${pkgs.liberation_ttf}/share/fonts:${pkgs.lato}/share/fonts/lato:${pkgs.raleway}/share/fonts:${pkgs.lmodern}/share/fonts
        '';
      };
    });
}
