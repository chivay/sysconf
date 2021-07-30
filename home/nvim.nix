{ config, lib, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-commentary
      vim-surround
      copilot-vim
      fugitive
      fzf-vim

      (nvim-treesitter.withPlugins (plugins:
        with plugins; [
          tree-sitter-bash
          tree-sitter-c
          tree-sitter-cpp
          tree-sitter-json
          tree-sitter-latex
          tree-sitter-nix
          tree-sitter-python
          tree-sitter-toml
          tree-sitter-yaml
          tree-sitter-zig
          tree-sitter-go
          nvim-treesitter-textobjects
        ]))
    ];
    extraConfig = ''
      let $FZF_DEFAULT_COMMAND = 'rg --files'

      let mapleader = ","
      au BufRead,BufNewFile *.nix setf nix

      set nocompatible
      set noswapfile
      set nobackup
      set ignorecase

      set number relativenumber

      set expandtab
      set shiftwidth=4
      set tabstop=4

      nmap <Leader>e :Files<enter>
      nmap <Leader>f :Buffers<enter>

      lua <<EOF
      require'nvim-treesitter.configs'.setup {
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      }
      EOF
    '';
  };
}
