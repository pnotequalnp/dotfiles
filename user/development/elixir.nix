{ pkgs, ... }:

{
  home.packages = [
    pkgs.elixir
    pkgs.elixir_ls
  ];
}
