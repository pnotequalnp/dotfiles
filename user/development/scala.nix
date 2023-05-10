{ pkgs, ... }:

{
  home.packages = [
    pkgs.sbt
    pkgs.metals
  ];
}
