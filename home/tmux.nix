{ ... }:
{
  programs.tmux = {
    enable = true;
    escapeTime = 0;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    extraConfig = ''
    set -g renumber-windows on
    '';
  };
}
