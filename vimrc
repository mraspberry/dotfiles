" == automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

" == remap semi-colon to colon and vice-versa
" nnoremap ; :
" nnoremap : ;

" == better copy paste behavior
set pastetoggle=<F2>
set clipboard=unnamed

" == rebind <Leader> key
let mapleader = ","

" == show the cursorline
set cursorline
" == easier movement between windows and tabs
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

map <Leader>n <esc>:tabnext<CR>
map <Leader>m <esc>:tabprevious<CR>

" == map sort function to a key
vnoremap <Leader>s :sort<CR>      

" == easier moving of code blocks for indentation
vnoremap < <gv
vnoremap > >gv

" == syntax highlighting
filetype off
filetype plugin indent on
set autoindent
syntax on
autocmd Filetype * setlocal formatoptions-=c formatoptions-=o formatoptions-=r

" == paragraph formatting
vmap Q gq
nmap Q gqap

nnoremap nh <ESC>:noh<CR>

" == tab stuff
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab

" == make search insensitive
set hlsearch
set ignorecase
set smartcase

" == set .subr files as shell
" == set a file named post_install as shell
" == set ini files to conf
au BufNewFile,BufRead *.subr set filetype=sh
au BufNewFile,BufRead post_install set filetype=sh
au BufNewFile,BufRead *.ini set filetype=conf

set bg=dark
set number

" == Enable all Python syntax highlighting
let python_highlight_all = 1

" == show matching () [] {}
set showmatch

" == Highlight the 81st character on a line to know when it crosses
highlight ColorColumn ctermbg=red
call matchadd('ColorColumn', '\%81v', 100)
