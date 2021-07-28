source $HOME/.config/nvim/themes/airline.vim
"source $HOME/.config/nvim/plug-config/coc.vim

set clipboard=unnamedplus
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
set encoding=utf-8
set number relativenumber
syntax enable
set noswapfile
set scrolloff=7
set backspace=indent,eol,start
"set colorcolumn=81 "can write over column, not past it
set fileformat=unix
set clipboard=unnamedplus
set mouse=a
set splitbelow
set splitright
set ignorecase
set fileignorecase
"set termguicolors

"command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

call plug#begin('~/.vim/plugged')

" Aesthetics
Plug 'owickstrom/vim-colors-paramount'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'lambdalisue/nerdfont.vim'
Plug 'psliwka/vim-smoothie'
Plug 'itchyny/lightline.vim'

" Language support
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neovimhaskell/haskell-vim'
Plug 'dag/vim-fish'
Plug 'sirver/ultisnips'
Plug 'mattn/emmet-vim'

" Utilities/convenience
Plug 'lambdalisue/suda.vim'
Plug 'szw/vim-maximizer'
Plug 'jiangmiao/auto-pairs'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'hugolgst/vimsence'
Plug 'dkarter/bullets.vim'
"Plug 'itchyny/vim-cursorword'

" Movement/navigation
Plug 'justinmk/vim-sneak'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dyng/ctrlsf.vim'
Plug 'voldikss/vim-floaterm'
Plug 'ptzz/lf.vim'
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'

" Git
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'junegunn/gv.vim'
Plug 'itchyny/vim-gitbranch'

call plug#end()

colorscheme paramount

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemode = ':t'
let g:airline#extensions#whitespace#enabled = 0
let g:airline_theme = 'minimalist'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''

" enable powerline fonts
let g:airline_powerline_fonts = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''

" Always show tabs
set showtabline=2

" We don't need to see things like -- INSERT -- anymore
set noshowmode

filetype plugin indent on

set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
set autoindent
set cindent

let g:mapleader = "\<Space>"
"nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
"nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>

map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

nnoremap <C-H> <C-W><C-W>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

map <ScrollWheelUp> <C-U>
map <ScrollWheelDown> <C-D>

"nmap <leader>gs :G<CR>
"nmap <leader>gh :diffget //3<CR>
"nmap <leader>gu :diffget //2<CR>

"nnoremap <C-p> :GFiles <CR>

nnoremap <leader><space> :History <CR>
nnoremap <leader>lf :Lf <CR>
nnoremap <leader>lc :Lfcd <CR>

nnoremap <leader>m :MaximizerToggle!<CR>

nnoremap <silent> <CR> :noh<CR>

nnoremap zn :tabnew<Space>
nnoremap zk :tabnext<CR>
nnoremap zj :tabprev<CR>
nnoremap zh :tabfirst<CR>
nnoremap zl :tablast<CR>

nnoremap K i<CR><Esc>k$

tnoremap <ESC> <C-\><C-n>

let s:wrapenabled = 0
function! ToggleWrap()
  set wrap nolist
  if s:wrapenabled
    set nolinebreak
    unmap j
    unmap k
    unmap 0
    unmap ^
    unmap $
    let s:wrapenabled = 0
  else
    set linebreak
    nnoremap j gj
    nnoremap k gk
    nnoremap 0 g0
    nnoremap ^ g^
    nnoremap $ g$
    vnoremap j gj
    vnoremap k gk
    vnoremap 0 g0
    vnoremap ^ g^
    vnoremap $ g$
    let s:wrapenabled = 1
  endif
endfunction
map <leader>w :call ToggleWrap()<CR>

let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/ultisnips']
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

autocmd FileType fish compiler fish
autocmd FileType hs set ts=2 sw=2 expandtab

let g:lf_map_keys = 0

let g:ctrlp_show_hidden = 1

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.git$',
  \ 'file': '\v\.(exe|so|dll|o)$',
  \ 'link': '',
  \ }

let g:ctrlsf_default_view_mode = 'compact'
let g:ctrlsf_auto_close = {
    \ "normal" : 0,
    \ "compact": 0
    \}

let g:ctrlsf_auto_focus = {
    \ "at": "start"
    \ }
nmap     <leader>ff <Plug>CtrlSFPrompt
vmap     <leader>ff <Plug>CtrlSFVwordPath
vmap     <leader>fF <Plug>CtrlSFVwordExec
nmap     <leader>fw <Plug>CtrlSFCwordPath
nmap     <leader>fW <Plug>CtrlSFPwordPath
nnoremap <leader>fo :CtrlSFOpen<CR>

let g:user_emmet_mode='n'
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
let g:user_emmet_leader_key='<leader>'
