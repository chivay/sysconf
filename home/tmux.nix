{ ... }:
{
  programs.tmux = {
    enable = true;
    escapeTime = 0;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    extraConfig = ''
      set -g default-terminal "screen-256color"
      set -g renumber-windows on
      set -g mouse on
    '';
  };
}
