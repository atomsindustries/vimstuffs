set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

" Experimental Settings -----------------------------------------------------{{{

let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4

set listchars=tab:\|\ ,trail:·,nbsp:_
set list

" Addes a mark where lines go over 80 columns
" https://youtu.be/aHm36-na4-4?t=234
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)

" }}}
" Vundle Setup --------------------------------------------------------------{{{

" set nocompatible is required by Vundle BUT it is also default in GVim setup,
" so leave it unless you are sure it needs to go

filetype off                  " required by Vundle
" set the runtime path to include Vundle and initialize
set rtp+=~/vimfiles/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'


" ========= Vundle Plugs START ==========

Plugin 'scrooloose/nerdtree'
Plugin 'bling/vim-airline'
"Plugin 'nathanaelkane/vim-indent-guides'


" ========= Vundle Plugs END ==========

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" }}}
" Set up Editor -------------------------------------------------------------{{{

colo atoms
set nowrap
set linebreak
set noswapfile
set number
set guifont=Consolas:h12
set cursorline
set ignorecase " not sure if or why this needs to be used with smartcase, just what I saw being done
set smartcase " Only case sensitive if capitals are in search string. using \c and \C can play with sensitivity
set textwidth=0 " Keeps vim from breaking line at col 80 while typing, could get broken by some syntax specific files

"Set directory of the current file as the working directory
"http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
autocmd BufEnter * lcd %:p:h

"Change where backup files are saved
set backupdir=d:\Vim\Backups

" Setup Folding
set foldmethod=marker

" }}}
" Movement " ----------------------------------------------------------------{{{

"Move by row instead by line
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" }}}
" Leader Boards -------------------------------------------------------------{{{

let mapleader=" "

" reverse J
nnoremap <leader>J a<cr><esc>

" movement
nnoremap <leader>j 7j
nnoremap <leader>k 7k

" o commands but without going into INSERT mode
nnoremap <leader>o o<esc>
nnoremap <leader>O O<esc>

nnoremap <leader>w <C-w>
nnoremap <leader>m `
nnoremap <leader><tab> *

" Copying/pasting text to the system clipboard.
noremap  <leader>p "+p
vnoremap <leader>y "+y
nnoremap <leader>y VV"+y
nnoremap <leader>Y "+y

nnoremap <leader>z za

" =========== New Leader Settings ==========
let mapleader=","
nnoremap <leader>k 10k
nnoremap <leader>j 10j
" }}}
" Line Return ---------------------------------------------------------------{{{

" Make sure Vim returns to the same line when you reopen a file.
" https://youtu.be/xZuy4gBghho?t=230
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

" }}}
" Abbreviations -------------------------------------------------------------{{{

" functions for abbrs
" https://bitbucket.org/sjl/dotfiles/src/tip/vim/vimrc
function! EatChar(pat)
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
endfunction

function! MakeSpacelessIabbrev(from, to)
    execute "iabbrev <silent> ".a:from." ".a:to."<C-R>=EatChar('\\s')<CR>"
endfunction
function! MakeSpacelessBufferIabbrev(from, to)
    execute "iabbrev <silent> <buffer> ".a:from." ".a:to."<C-R>=EatChar('\\s')<CR>"
endfunction

call MakeSpacelessIabbrev('fls/', '" HEADER -----------------------------------------------------------{{{<enter>')
call MakeSpacelessIabbrev('fle/', '<enter>" }}}')
call MakeSpacelessIabbrev('flf/', '" HEADER -----------------------------------------------------------{{{<enter><enter><enter><enter>" }}}<esc>kk')

" }}}
" Text Manipulations --------------------------------------------------------{{{

" increment/decrement
nnoremap <A-a> <C-a>
nnoremap <A-x> <C-x>

"Capital Y yanks till end of line, instead of whole line
nnoremap Y y$

" }}}
" Miscellaneous -------------------------------------------------------------{{{

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" }}}
" Splitsville ---------------------------------------------------------------{{{

"Change location of split views to be under for horizontal and to the right for vertical
set splitbelow
set splitright

" }}}
" MyDiff Function -----------------------------------------------------------{{{

"2018-08-09-1209 MyDiff update Added ! to end of function for suggestion here:
"https://stackoverflow.com/questions/39706615/how-to-fix-this-error-e122-function-mydiff-already-exists-add-to-replace-it
set diffexpr=MyDiff()
function! MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

" }}}
" Folding -------------------------------------------------------------------{{{



" }}}
