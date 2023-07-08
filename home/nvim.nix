{ config, lib, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      # a nice colorscheme
      # https://github.com/phanviet/vim-monokai-pro
      vim-monokai-pro

      # support for a plethora of languages
      # https://github.com/sheerun/vim-polyglot
      vim-polyglot

      # comment out stuff easily
      # https://github.com/tpope/vim-commentary
      # :h commentary

      vim-commentary
      # manage brackets, parents, tags etc.
      # https://github.com/tpope/vim-surround
      # :h surround
      vim-surround

      # Git helper for vim 
      fugitive
      # open file in GitHub with  :GBrowse
      vim-rhubarb

      fzf-vim

      hop-nvim
    ];
    extraConfig = builtins.readFile ./init.vim;
    extraPackages = with pkgs; [
      wl-clipboard
      pyright
      rust-analyzer
      zls
    ];
  };
}
