{ ... }:
{
  programs.htop = {
    enable = true;
    settings = {
      enable_mouse = true;
      hide_userland_threads = true;
      show_program_path = false;
      tree_view = true;
    };
  };
}
