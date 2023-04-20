{ pkgs, ... }:

{
  home.packages = [
    pkgs.ocaml
    pkgs.ocamlPackages.ocaml-lsp
  ];
}
