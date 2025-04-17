{ pkgs, ... }:

{
  home.packages = with pkgs; [ hyperfine insomnia scc ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      aaron-bond.better-comments
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      eamodio.gitlens
      jnoortheen.nix-ide
      mkhl.direnv
      ms-vscode.hexeditor
      tamasfe.even-better-toml
    ];
  };
}
