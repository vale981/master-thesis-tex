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
          cleveref multirow bbold unicode-math biblatex-phys xpatch;
      };
    in rec {
      packages = {
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
            cp index.pdf $out/
          '';
        };
      };
      defaultPackage = packages.document;
    });
}
