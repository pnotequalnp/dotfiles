{ pkgs, ... }:

{
  home.packages = with pkgs; [ hyperfine insomnia scc vscodium ];
}
