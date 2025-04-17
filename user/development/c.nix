{ pkgs, ... }:

{
  home.packages = [
    pkgs.clang
    pkgs.clang-tools
    pkgs.valgrind
  ];

  programs.vscode.profiles.default.extensions = [ pkgs.vscode-extensions.ms-vscode.cpptools ];
}
