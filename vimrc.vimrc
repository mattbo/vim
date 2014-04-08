"
" .vimrc
" 
" Put together from scratch
" By mattbo
" 8/26/08
" 
" Based loosely on Smylers's .vimrc
" http://www.stripey.com/vim/vimrc.html
"

" first, clear any existing autocommands:
autocmd!

" Next, turn off Vi compatibility mode!
set nocompatible

" Set up Vundle.  Must come before filetype detection!
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundel manage Vundle (required)
Bundle 'gmarik/vundle'

"My Bundles
 
"From github
Bundle 'tpope/vim-surround'
Bundle 'scrooloose/syntastic'
Bundle 'shougo/neocomplcache'
Bundle 'altercation/vim-colors-solarized'
Bundle 'goldfeld/vim-seek'

"From vim-scripts github account
"Bundle 'FuzzyFinder'
Bundle 'SQLUtilities'
Bundle 'django.vim'

"Other (non-github) repos
"Bundle 'git://git.wincent.com/command-t.git'

" End Vundle config
" See the end of this file for bundle-specific configuration


" enable filetype detection:
filetype on
filetype plugin on
filetype indent on

""""
" Terminal settings
""""
" `XTerm', `RXVT', `Gnome Terminal', and `Konsole' all claim to be "xterm";
" `KVT' claims to be "xterm-color":
if &term =~ 'xterm'

  " `Gnome Terminal' fortunately sets $COLORTERM; it needs <BkSpc> and <Del>
  " fixing, and it has a bug which causes spurious "c"s to appear, which can be
  " fixed by unsetting t_RV:
  if $COLORTERM == 'gnome-terminal'
    execute 'set t_kb=' . nr2char(8)
    " [Char 8 is <Ctrl>+H.]
    fixdel
    set t_RV=
    
  " Apple's Terminal sets TERM_PROGRAM to Apple_Terminal.  No fixes are 
  " required
  elseif $TERM_PROGRAM == 'Apple_Terminal'

  " `XTerm', `Konsole', and `KVT' all also need <BkSpc> and <Del> fixing;
  " there's no easy way of distinguishing these terminals from other things
  " that claim to be "xterm", but `RXVT' sets $COLORTERM to "rxvt" and these
  " don't:
  elseif $COLORTERM == ''
    execute 'set t_kb=' . nr2char(8)
    fixdel

  " The above won't work if an `XTerm' or `KVT' is started from within a `Gnome
  " Terminal' or an `RXVT': the $COLORTERM setting will propagate; it's always
  " OK with `Konsole' which explicitly sets $COLORTERM to "".
  
  endif
endif

" Finally, deal with screen.  Screen sets $TERM = 'screen'.  Set it back to 
" xterm and things start working right...
if &term =~ 'screen'
  set term=xterm
endif


" Set backspace to kill anything in insert mode
set bs=indent,eol,start

" change the termcap settings so titlestring affects the tab title
set t_ts=]1;
set title
autocmd BufReadPost *	:set titlestring=%t


""""
" User Interface
""""

" Full python syntax highlighting
let python_highlight_all=1

" have syntax highlighting in terminals which can display colours:
if has('syntax') && (&t_Co > 2)
  syntax on
endif

" have fifty lines of command-line (etc) history:
set history=50
" remember all of these between sessions, but only 10 search terms; also
" remember info for 10 files, but never any on removable disks, don't remember
" marks in files, don't rehighlight old search patterns, and only save up to
" 100 lines of registers; including @10 in there should restrict input buffer
" but it causes an error for me:
set viminfo=/10,'10,r/mnt/zip,r/mnt/floppy,f0,h,\"100

" have command-line completion <Tab> (for filenames, help topics, option names)
" first list the available options and complete the longest common part, then
" have further <Tab>s cycle through the possibilities:
set wildmode=list:longest,full

" use "[RO]" for "[readonly]" to save space in the message line:
set shortmess+=r

" display the current mode, partially-typed commands, and the cursor position
" in the status line:
set showmode
set showcmd

" status line fanciness
" :help statusline for the full list of madness
set laststatus=2
set statusline=   " clear the statusline for when vimrc is reloaded
"set statusline+=%f\                          " file name
set statusline+=%-.30F\                          " full path (w/ filename)
set statusline+=%n\                          " buffer number
"set statusline+=%h                           " help flag(redundant w/filetype)
set statusline+=%m%r%w                     " flags (modified, RO, preview)
set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight
"set statusline+=%b,0x%-8B\                   " current char (ascii decimal/hex)
set statusline+=%-14.(%l,%c%V%)\ %<%P        " line, column, virt col percent


" when using list, keep tabs at their full width and display `arrows':
execute 'set listchars+=tab:' . nr2char(187) . nr2char(183)
" (Character 187 is a right double-chevron, and 183 a mid-dot.)

" don't have files trying to override this .vimrc:
set nomodeline

" * Text Formatting -- General

" don't make it look like there are line breaks where there aren't:
"set nowrap

" use indents of 4 spaces, and have them copied down lines:
set shiftwidth=4
set shiftround
set expandtab
set autoindent
set tabstop=4

"MSB let's be positive and set formatoptions...
":help fo-table to see a full listing of available options
set formatoptions=qc
set textwidth=80

" Wildmenus
:set wildmenu

" * Text Formatting -- Specific File Formats

" recognize anything in my .Postponed directory as a news article, and anything
" at all with a .txt extension as being human-language text [this clobbers the
" `help' filetype, but that doesn't seem to prevent help from working properly]:
augroup filetype
  autocmd BufNewFile,BufRead */.Postponed/* set filetype=mail
  autocmd BufNewFile,BufRead *.txt set filetype=human
augroup END

" treat lines starting with a quote mark as comments (for `Vim' files, such as
" this very one!), and colons as well so that reformatting usenet messages from
" `Tin' users works OK:
"au BufRead,BufNewFile .vimrc,*.vim set comments+=b:\"
au FileType vim set comments+=b:\"

" in human-language files, automatically format everything at 72 chars:
autocmd FileType mail,human set formatoptions+=t textwidth=72


" for Perl programming, have things in braces indenting themselves:
autocmd FileType perl set smartindent

" for CSS, also have things in braces indented:
autocmd FileType css set smartindent

" for HTML, generally format text, but if a long line has been created leave it
" alone when editing:
autocmd FileType html set formatoptions=qlc

" for both CSS and HTML, use two spaces for tabs to make
" files a few bytes smaller:
autocmd FileType html,css set expandtab tabstop=2

" This is what we want to do when opening a new .java file : 
:function JavaNewFile()
":	insert 
":	/*
":	 * 
":	.
":	echo %
":	insert
":	 *
":	 * Created on
":	.
":	read !date
":	insert
":	 */
:endfunction

:autocmd BufNewFile java :call JavaNewFile()<CR>

" * Search & Replace

" make searches case-insensitive, unless they contain upper-case letters:
set ignorecase
set smartcase

" show the `best match so far' as search strings are typed:
set incsearch

" assume the /g flag on :s substitutions to replace all matches in a line:
set gdefault

" * Keystrokes -- Moving Around

" have the h and l cursor keys wrap between lines (like <Space> and <BkSpc> do
" by default), and ~ convert case over line breaks; also have the cursor keys
" wrap in insert mode:
set whichwrap=h,l,~,[,]

" scroll the window (but leaving the cursor in the same place) by a couple of
" lines up/down with <Ins>/<Del> (like in `Lynx'):
noremap <Ins> 2<C-Y>
noremap <Del> 2<C-E>
" [<Ins> by default is like i, and <Del> like x.]

" use <Ctrl>+N/<Ctrl>+P to cycle through files:
nnoremap <C-N> :next<CR>
nnoremap <C-P> :prev<CR>
" [<Ctrl>+N by default is like j, and <Ctrl>+P like k.]

" have % bounce between angled brackets, as well as t'other kinds:
set matchpairs+=<:>

" have <F1> prompt for a help topic, rather than displaying the introduction
" page, and have it do this from any mode:
nnoremap <F1> :help<Space>
vmap <F1> <C-C><F1>
omap <F1> <C-C><F1>
map! <F1> <C-C><F1>


" * Keystrokes -- Formatting

" have Q reformat the current paragraph (or selected text if there is any):
nnoremap Q gqap
vnoremap Q gq

" have the usual indentation keystrokes still work in visual mode:
vnoremap <C-T> >
vnoremap <C-D> <LT>
vmap <Tab> <C-T>
vmap <S-Tab> <C-D>

" have Y behave analogously to D and C rather than to dd and cc (which is
" already done by yy):
noremap Y y$

" * Keystrokes -- Toggles

" Keystrokes to toggle options are defined here.  They are all set to normal
" mode keystrokes beginning \t but some function keys (which won't work in all
" terminals) are also mapped.

" have \tp ("toggle paste") toggle paste on/off and report the change, and
" where possible also have <F4> do this both in normal and insert mode:
nnoremap \tp :set invpaste paste?<CR>
nmap <F4> \tp
imap <F4> <C-O>\tp
set pastetoggle=<F4>

" have \tf ("toggle format") toggle the automatic insertion of line breaks
" during typing and report the change:
nnoremap \tf :if &fo =~ 't' <Bar> set fo-=t <Bar> else <Bar> set fo+=t <Bar>
  \ endif <Bar> set fo?<CR>
nmap <F3> \tf
imap <F3> <C-O>\tf

" have \tl ("toggle list") toggle list on/off and report the change:
nnoremap \tl :set invlist list?<CR>
nmap <F2> \tl

" have \th ("toggle highlight") toggle highlighting of search matches, and
" report the change:
nnoremap \th :set invhls hls?<CR>


" * Keystrokes -- Insert Mode

" allow <BkSpc> to delete line breaks, beyond the start of the current
" insertion, and over indentations:
set backspace=eol,start,indent

" have <Tab> (and <Shift>+<Tab> where it works) change the level of
" indentation:
inoremap <Tab> <C-T>
inoremap <S-Tab> <C-D>
" [<Ctrl>+V <Tab> still inserts an actual tab character.]

" end of Smylers's .vimrc
"

" External .vim files 
" Specific to Python and C
source ~/.vim/PyC.vim
" Django template indent from
" bitbucket.org:sjl/dotfiles/src/tip/vim/bundle/django-custom/indent/htmldjango.vim'
source ~/.vim/htmldjango.vim

colorscheme desert

" Settings specific to the bundles loaded at the top
let g:syntastic_python_checkers = ['flake8']
