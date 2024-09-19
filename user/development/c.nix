{ pkgs, ... }:

{
  home.packages = [
    pkgs.clang
    pkgs.clang-tools
    pkgs.valgrind
  ];

  programs.vscode.extensions = [ pkgs.vscode-extensions.ms-vscode.cpptools ];
}
