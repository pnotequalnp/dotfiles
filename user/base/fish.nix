{ config, ...}:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      bind -k nul -M insert 'accept-autosuggestion'
    '';
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
}
