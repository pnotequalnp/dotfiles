{ pkgs, ... }:

{
  home.packages = [
    pkgs.clang
    pkgs.clang-tools
    pkgs.valgrind
  ];
}
