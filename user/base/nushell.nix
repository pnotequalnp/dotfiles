{
  programs.nushell = {
    enable = true;
    configFile.text = ''
      let-env config = {
        show_banner: false
        edit_mode: vi
      }

      let-env STARSHIP_SHELL = "nu"

      def create_left_prompt [] {
        starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=$env.LAST_EXIT_CODE)'
      }

      let-env PROMPT_COMMAND = { create_left_prompt }
      let-env PROMPT_COMMAND_RIGHT = ""

      let-env PROMPT_INDICATOR = ""
    '';
    envFile.text = "";
  };
}