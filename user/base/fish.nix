{ ...}:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      bind -M insert ctrl-space 'accept-autosuggestion'
    '';
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
}
