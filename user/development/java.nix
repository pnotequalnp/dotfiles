{ pkgs, ... }:

{
  home.packages = [
    pkgs.openjdk
    pkgs.jdt-language-server
  ];
}
