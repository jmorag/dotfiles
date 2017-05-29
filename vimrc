"---------------------------------
" Big rewrite of vimrc
"---------------------------------

" Don't try to be vi compatible
set nocompatible

" Plugin settings ----{{{

" Helps force plugins to load correctly when it is turned back on below
filetype off

" Bootstrap vim plug
if empty(glob("~/.vim/autoload/plug.vim"))
    " Ensure all needed directories exist
    execute '!mkdir -p ~/.vim/plugged'
    execute '!mkdir -p ~/.vim/autoload'
    " Download the actual plugin manager
    execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    normal! PlugInstall
endif

call plug#begin('~/.vim/plugged')

"Completion
Plug 'Valloric/YouCompleteMe', {'do': './install.py -all'}
Plug 'rdnetto/YCM-Generator'
"Easier text editing
Plug 'Raimondi/delimitMate'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
"Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
"Aesthetics
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"File Navigation
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-vinegar'
"Git
Plug 'tpope/vim-fugitive'

call plug#end()
" End Plugin Settings ----}}}


" Vimscript file settings ---------------------- {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    autocmd BufWritePost vimrc source %
augroup END
" }}}

" 
" Airline Fonts
let g:airline_powerline_fonts = 1

" Python autocompletion
let g:ycm_python_binary_path = '/usr/bin/python3'

" Stop asking about .ycm_extra_conf.py file
let g:ycm_extra_conf_globlist = ['~/*']

" Use bare bones global ycm conf as default
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_extra_conf.py'

" Remap ultisnips to <C-j> so <Tab> isn't overloaded
let g:UltiSnipsExpandTrigger="<c-j>"
" Let Ultisnips split window
let g:UltiSnipsEditSplit="vertical"

" Define default directory for custom snippets
let g:UltiSnipsSnippetsDir="~/.vim/bundle/ultisnips/UltiSnips"

" Turn on syntax highlighting
syntax on

let mapleader = "\<Space>"
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

"Since comma isn't the leader, use it to save
nnoremap , :wall<CR>

" EasyMotion only press leader once
map <Leader> <Plug>(easymotion-prefix)
" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>l <Plug>(easymotion-bd-jk)
nmap <Leader>l <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" Ycmd Fixit
nnoremap <Leader>h :YcmCompleter FixIt<CR>

" DelimitMate Config
let delimitMate_expand_cr=2

" For easier copying into vim
set pastetoggle=<F2>
set clipboard=unnamed

" Security
set modelines=0

" Show line numbers (experiment with relative later)
set number

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell

" Encoding
set encoding=utf-8

" Swap files are annoying
set noswapfile

"Tab autocomplete (bashlike)
set wildmode=longest,list

" Whitespace
set wrap
set textwidth=79
set formatoptions=tcqrn1
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Move across windows normally
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
nnoremap <leader><Space> :nohlsearch<cr>
" clear search

" Remap escape key.
inoremap fd <Esc>

" Formatting
map <leader>q gqip

nnoremap <buffer> <C-B> :exec ':w !python' shellescape(@%, 1)<cr>

" Color scheme (terminal)
syntax enable
set t_Co=256
set background=dark
colorscheme solarized
