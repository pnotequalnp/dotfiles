{ pkgs, ... }:

{
  home.packages = [
    pkgs.nodejs
    pkgs.nodePackages.typescript-language-server
  ];
}
