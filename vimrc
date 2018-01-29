"---------------------------------
" Big rewrite of vimrc fix easymotion
"---------------------------------

" Plugin settings ----{{{

" Don't try to be vi compatible
set nocompatible

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
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'junegunn/vim-easy-align'
"Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
"Aesthetics
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"File Navigation
" Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } 
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
" Plug 'tpope/vim-vinegar'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
"Git
Plug 'tpope/vim-fugitive'
"Languages
Plug 'lervag/vimtex'
Plug 'w0rp/ale'

call plug#end()
" End Plugin Settings ----}}}

" Filetype specific settings ---------------------- {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

augroup filetype_config
    autocmd!
    autocmd FileType conf setlocal foldmethod=marker
augroup END

augroup filetype_all
    autocmd!
    autocmd InsertLeave * set cursorline
    autocmd InsertEnter * set nocursorline
augroup END

" }}}

" Misc Key mappings {{{ " 

let mapleader = "\<Space>"
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

"Since comma isn't the leader, use it to save
nnoremap , :wall<CR>

" Toggle comment with single key
nmap ' <Plug>CommentaryLine
nmap " gcap
vmap ' <Plug>Commentary

" Ycmd Fixit
nnoremap <Leader>h :YcmCompleter FixIt<CR>

" Remap escape key.
inoremap fd <Esc>

" Fix behavior of Y so it matches C and D
nnoremap Y y$

" Formatting
nmap = <Plug>(EasyAlign)
vmap = <Plug>(EasyAlign)

" Access git
nnoremap <Leader>g :Gstatus<CR>

" Weird python thing I don't understand
nnoremap <buffer> <C-B> :exec ':w !python' shellescape(@%, 1)<cr>

" }}} Key mappings "

" Navigation {{{

" Easymotion config
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1 " 1 matches !, etc.
nmap f <Plug>(easymotion-sl)

" Let's take a stab at using timer to emulate avy-go-to-char-timer
" TODO: this is horribly hacky and there must be a better way to accomplish
" this
function! PressEnter(timer)
    :call feedkeys("\<CR>")
endfunction
" garbage mapping - can't figure out how to just call (easymotion-sn)
nmap <c-_> <Plug>(easymotion-sn)
function! GoToCharTimer()
    :call feedkeys("\<c-_>")
    let timer=timer_start(2500, 'PressEnter')
    :set nohlsearch
endfunction    

" Now <c-f> behaves like avy-go-to-char-timer
nnoremap <c-f> :call GoToCharTimer()<CR>
omap <c-f> <Plug>(easymotion-tn)

" Incsearch 
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" Move up/down visual lines
nnoremap j gj
nnoremap k gk

" Move across windows normally
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Open NerdTree
nnoremap - :NERDTreeToggle<CR>

" Close vim if all that's left open in NERDTree
augroup nerd_tree
    autocmd!
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

" Fuzzy file finding
nnoremap <c-p> :Files<CR>
set grepprg=rg\ --vimgrep

" Fuzzy term finding in project with fzf 
" https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
command! -bang -nargs=* Find call fzf#vim#grep('rg --column 
 \ --line-number --no-heading 
 \ --fixed-strings --ignore-case 
 \ --follow --glob "!.git/*" 
 \ --color "always" '.shellescape(<q-args>), 1, <bang>0)
 " \ --no-ignore --hidden 

nnoremap s :Find<CR>
" }}}


" Completion and snippets {{{ "

" Python autocompletion
let g:ycm_python_binary_path = '/usr/bin/python3'

" Stop asking about .ycm_extra_conf.py file
let g:ycm_extra_conf_globlist = ['~/*']

" Use bare bones global ycm conf as default
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_extra_conf.py'

" Remap ultisnips to <C-j> so <Tab> isn't overloaded
" let g:UltiSnipsExpandTrigger="<C-j>"
let g:ycm_key_list_select_completion=['<C-j>']
" previous completion select buggy
" let g:ycm_key_list_select_previous_completion=["<C-k>"]

" Let Ultisnips split window
let g:UltiSnipsEditSplit="vertical"

" Define default directory for custom snippets
let g:UltiSnipsSnippetsDir="~/.vim/mysnippets"

" DelimitMate Config
let delimitMate_expand_cr=2

" Tab autocomplete (bashlike)
set wildmode=longest,list

" Latex autocompletion and viewing
if !exists('g:ycm_semantic_triggers')
    let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.tex = [
    \ 're!\\[A-Za-z]*cite[A-Za-z]*(\[[^]]*\]){0,2}{[^}]*',
    \ 're!\\[A-Za-z]*ref({[^}]*|range{([^,{}]*(}{)?))',
    \ 're!\\hyperref\[[^]]*',
    \ 're!\\includegraphics\*?(\[[^]]*\]){0,2}{[^}]*',
    \ 're!\\(include(only)?|input){[^}]*',
    \ 're!\\\a*(gls|Gls|GLS)(pl)?\a*(\s*\[[^]]*\]){0,2}\s*\{[^}]*',
    \ 're!\\includepdf(\s*\[[^]]*\])?\s*\{[^}]*',
    \ 're!\\includestandalone(\s*\[[^]]*\])?\s*\{[^}]*',
    \ ]

let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'

" This adds a callback hook that updates Skim after compilation
let g:vimtex_latexmk_callback_hooks = ['UpdateSkim']
function! UpdateSkim(status)
  if !a:status | return | endif

  let l:out = b:vimtex.out()
  let l:tex = expand('%:p')
  let l:cmd = [g:vimtex_view_general_viewer, '-r']
  if !empty(system('pgrep Skim'))
    call extend(l:cmd, ['-g'])
  endif
  if has('nvim')
    call jobstart(l:cmd + [line('.'), l:out, l:tex])
  elseif has('job')
    call job_start(l:cmd + [line('.'), l:out, l:tex])
  else
    call system(join(l:cmd + [line('.'), shellescape(l:out), shellescape(l:tex)], ' '))
  endif
endfunction

" Prevent .tex files from being treated as plain text
let g:tex_flavor = 'latex'

" Ocaml merlin
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

" }}} Completion and snippets "

" Miscellaneous {{{ "

" Airline Fonts
let g:airline_powerline_fonts = 1

" Security
set modelines=0

" Show line numbers
set number

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell

" Encoding
set encoding=utf-8

" Use mouse to resize buffers
set mouse=a

" Turn on syntax highlighting
syntax on

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

" Allow hidden buffers
set hidden

" Rendering
set ttyfast
set autoread

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

" Color scheme (terminal)
syntax enable
set t_Co=256
set background=dark
colorscheme solarized

" For easier copying into vim
set pastetoggle=<F2>
set clipboard=unnamed

" Swap files are annoying
set noswapfile

" }}} Miscellaneous "

