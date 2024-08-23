{ config, pkgs, ... }:

let
  haskell = pkgs.haskell.packages.ghc98;
  packages = p: with p; [
    adjunctions
    aeson
    async
    base
    bytestring
    comonad
    constraints
    containers
    contravariant
    criterion
    data-fix
    distributive
    exceptions
    free
    foldl
    kan-extensions
    lens
    megaparsec
    mono-traversable
    mtl
    parser-combinators
    pretty-simple
    prettyprinter
    primitive
    profunctors
    QuickCheck
    random
    recursion-schemes
    reflection
    selective
    semigroupoids
    stm
    template-haskell
    text
    text-short
    text-show
    th-abstraction
    transformers
    unordered-containers
  ];
 in {
  home.packages = with haskell; [
    cabal-fmt
    cabal-install
    cabal-plan
    fourmolu
    (ghcWithHoogle packages)
    haskell-language-server
    hlint
    ghcid
  ];

  home.file = {
    ".ghc/ghci.conf".text = ''
      :set +m
      :set prompt "\ESC[1;34m%s\n\ESC[0;38;5;38mλ \ESC[m> "
      :set prompt-cont "  | "
      :set -XNoStarIsType
      :set -Wno-unused-top-binds
      :set -package pretty-simple

      :seti -XPartialTypeSignatures -XNamedWildCards
      :seti -interactive-print=Text.Pretty.Simple.pPrint
      :seti -Wall -Wcompat -Widentities -Wredundant-constraints
      :seti -Wno-partial-type-signatures -Wno-type-defaults -Wno-name-shadowing
      :seti -fno-defer-type-errors -fno-show-valid-hole-fits
    '';
    ".haskeline".text = "editMode: Vi";
  };

  home.sessionVariables.CABAL_DIR = "${config.xdg.dataHome}/cabal";
  home.sessionPath = ["${config.xdg.dataHome}/cabal/bin"];
}
