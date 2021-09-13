""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
set encoding=utf-8
set number relativenumber
syntax enable
syntax on
set nocompatible
set noswapfile
set scrolloff=7
set backspace=indent,eol,start
"set colorcolumn=81 "can write over column, not past it
set fileformat=unix
set mouse=a
set splitbelow
set splitright
set ignorecase
set fileignorecase
set termguicolors
set hidden

set list
set listchars=tab:·\ 

set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkon100

let g:gruvbox_contrast_dark='soft'
colorscheme gruvbox

" Always show tabs
set showtabline=2

" We don't need to see things like -- INSERT -- anymore
set noshowmode

filetype plugin on
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

"map <ScrollWheelUp> <C-U>
"map <ScrollWheelDown> <C-D>

"nmap <leader>gs :G<CR>
"nmap <leader>gh :diffget //3<CR>
"nmap <leader>gu :diffget //2<CR>

"nnoremap <C-p> :GFiles <CR>

nnoremap <leader><space> :History <CR>
nnoremap <leader>lf :Lf <CR>
nnoremap <leader>lc :Lfcd <CR>

"nnoremap <leader>m :MaximizerToggle!<CR>

nnoremap <silent> <CR> :noh<CR>

nnoremap <leader>/ :BLines<CR>

nnoremap <silent> <Tab>n :enew<CR>
nnoremap <silent> <Tab>k :bnext<CR>
nnoremap <silent> <Tab>j :bprevious<CR>
nnoremap <silent> <Tab>h :bfirst<CR>
nnoremap <silent> <Tab>l :blast<CR>
nnoremap <silent> <Tab>q :bd<CR>
nnoremap <silent> <Tab>Q :bd!<CR>

"nnoremap <silent>    <Tab>j :BufferPrevious<CR>
"nnoremap <silent>    <Tab>k :BufferNext<CR>
"
"nnoremap <silent>    <Tab>J :BufferMovePrevious<CR>
"nnoremap <silent>    <Tab>K :BufferMoveNext<CR>
"
"nnoremap <silent>    <Tab>h :BufferGoto 1<CR>
"nnoremap <silent>    <Tab>l :BufferLast<CR>
"
"nnoremap <silent>    <Tab>1 :BufferGoto 1<CR>
"nnoremap <silent>    <Tab>2 :BufferGoto 2<CR>
"nnoremap <silent>    <Tab>3 :BufferGoto 3<CR>
"nnoremap <silent>    <Tab>4 :BufferGoto 4<CR>
"nnoremap <silent>    <Tab>5 :BufferGoto 5<CR>
"nnoremap <silent>    <Tab>6 :BufferGoto 6<CR>
"nnoremap <silent>    <Tab>7 :BufferGoto 7<CR>
"nnoremap <silent>    <Tab>8 :BufferGoto 8<CR>
"nnoremap <silent>    <Tab>9 :BufferGoto 9<CR>
"
"nnoremap <silent>    <Tab>q :BufferClose<CR>
"
"let bufferline.icon_close_tab = ''
"let bufferline.icon_close_tab_modified = '●'
"let bufferline.animation = v:true
"let bufferline.auto_hide = v:true

nnoremap K i<CR><Esc>k$

tnoremap <ESC> <C-\><C-n>

nnoremap Y yg_

vnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y
nnoremap <leader>y "+y
nnoremap <leader>yy "+yy

nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

let s:twoSpaceMode = 0
function! ToggleTabMode()
	if s:twoSpaceMode
		set ts=4 sw=4 noexpandtab
		let s:twoSpaceMode = 0
	else
		set ts=2 sw=2 expandtab
		let s:twoSpaceMode = 1
	endif
endfunction


map <leader>t :call ToggleTabMode()<CR>

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
autocmd FileType nix set ts=4 sw=4 noexpandtab
autocmd FileType haskell set ts=2 sw=2 expandtab

let g:lf_map_keys=0
let g:lf_open_new_tab=0
let g:lf_replace_netrw = 1

let g:ctrlp_show_hidden = 1

let g:ctrlp_max_files = 0

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](target|node_modules|\.git)$',
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

let g:airline_mode_map = {
    \ '__'     : '-',
    \ 'c'      : 'C',
    \ 'i'      : 'I',
    \ 'ic'     : 'I',
    \ 'ix'     : 'I',
    \ 'n'      : 'N',
    \ 'multi'  : 'M',
    \ 'ni'     : 'N',
    \ 'no'     : 'N',
    \ 'R'      : 'R',
    \ 'Rv'     : 'R',
    \ 's'      : 'S',
    \ 'S'      : 'S',
    \ ''     : 'S',
    \ 't'      : 'T',
    \ 'v'      : 'V',
    \ 'V'      : 'VL',
    \ ''     : 'VB',
    \ }

let g:airline_focuslost_inactive = 1
let g:airline_stl_path_style = 'short'

let g:airline_section_z = ''

let g:user_emmet_mode='a'
let g:user_emmet_install_global = 1
"autocmd FileType html,css,ejs,js EmmetInstall
"let g:user_emmet_leader_key='<leader>'

let g:suda_smart_edit = 1

let g:vimsence_small_text = 'NeoVim'
let g:vimsence_small_image = 'neovim'

set signcolumn=yes
"
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <leader>wg jwwiglossary/<esc>
let g:vimwiki_list = [{'path':'/home/alexs/vimwiki', 'syntax':'markdown', 'ext':'.md'}]
let g:vimwiki_markdown_link_ext = 1
let g:taskwiki_markup_syntax = 'markdown'
let g:markdown_folding = 1
autocmd FileType markdown let b:coc_suggest_disable = 1
