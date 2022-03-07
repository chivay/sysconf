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
      zig-vim
      rust-vim
      nvim-lspconfig
      coq_nvim

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
          tree-sitter-rust
          nvim-treesitter-textobjects
        ]))
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
