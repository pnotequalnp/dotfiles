{ pkgs, ... }:

{
  home.packages = with pkgs; [ insomnia scc ];
}
