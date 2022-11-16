{ config, pkgs, ... }:

let
  haskell = pkgs.haskell.packages.ghc92;
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
    effectful
    exceptions
    free
    kan-extensions
    lens
    megaparsec
    mtl
    prettyprinter
    primitive
    profunctors
    QuickCheck
    random
    recursion-schemes
    semigroupoids
    stm
    text
    text-show
    transformers
  ];
 in {
  home.packages = with haskell; [
    cabal-install
    fourmolu
    (ghcWithHoogle packages)
    haskell-language-server
    hlint
    ghcid
  ];

  home.file = {
    ".ghc/ghci.conf".text = ''
    '';
    ".haskeline".text = "editMode: Vi";
  };

  home.sessionVariables.CABAL_DIR = "${config.xdg.dataHome}/cabal";
}