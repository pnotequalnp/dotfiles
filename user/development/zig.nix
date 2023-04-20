{ pkgs, ... }:

{
  home.packages = [
    pkgs.zig
    pkgs.zls
  ];
}
