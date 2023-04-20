{ pkgs, ... }:

{
  home.packages = [
    pkgs.kotlin
    pkgs.kotlin-language-server
  ];
}
