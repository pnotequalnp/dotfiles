{ config, ...}:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      bind -k nul -M insert 'accept-autosuggestion'
    '';
  };
}
