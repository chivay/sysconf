let $FZF_DEFAULT_COMMAND = 'rg --files'

set background=dark
set termguicolors
colorscheme monokai_pro

" Use system clipboard for yanks and pastes
" I wonder if it's useful tho
set clipboard=unnamed
set clipboard=unnamedplus

" Use , as leader
let mapleader = ","

" Disable swapfile
set noswapfile
" Disable backup files
set nobackup

" Ignore case when using lowercase patterns
set ignorecase
" But consider case when any uppercase is used
set smartcase

" Enable relative line numbers
set number relativenumber

" tab is 4 spaces
set expandtab
set shiftwidth=4
set tabstop=4

" ,e to fzf for a file from current directory
nmap <Leader>e :Files<enter>
" ,f to fzf open buffers
nmap <Leader>f :Buffers<enter>

nmap <Leader>g :HopWord<enter>

lua << EOF
require'hop'.setup {}
vim.api.nvim_create_user_command(
  'ZigStdLib',
  function(input)
    zig_std_path = io.popen("zig env | jq -r '.std_dir'"):read("*a")
    vim.cmd('tabnew')
    vim.cmd(string.format('tcd %s', zig_std_path))
    vim.cmd(":Files")
  end,
  {}
)
EOF
