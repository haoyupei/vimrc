""""""""""""""""""""""""""""""""""""""""""""""
" => General
""""""""""""""""""""""""""""""""""""""""""""""
" Set how many lines of history VIM has to remermber
set history=700

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader=","
let g:mapleader="," "Why a extra 'g:mapleader' variable, after 'mapleader'

" Fast saving
nmap <leader>w :w!<cr>

" Ignore case when searching
set ignorecase " equivalent to '\ckeyword' when searching '\c' means case-ignored

""""""""""""""""""""""""""""""""""""""""""""""
" ==> set encoding and fileformats
""""""""""""""""""""""""""""""""""""""""""""""
" set UTF8 as standard encoding and en_US as the standard language
set encoding=utf8

" 解决中文乱码问题
let &termencoding=&encoding

" file encoding, especially 'character encoding'
" 简体中文
set fileencodings=ucs-bom,utf-8,gb2312,cp936,big5,shift-jis,euc-jp,euc-kr,latin1,chinese

if has ("win32")
    set fileencoding=chinese
else
    set fileencoding=utf8
endif


" Use Unix as the standard file type
set ffs=unix,dos,mac

" 处理 consle/command line 乱码
"language messages zh_CN.utf-8

if has("win32")
"处理菜单及右键菜单乱码
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
endif

""""""""""""""""""""""""""""""""""""""""""""""
" ==> Function *MySys* : Detect Opertaring System Platform

""""""""""""""""""""""""""""""""""""""""""""""
function! MySys()
    if has("win32")
        return 'windows'
    else
        return 'linux'
    endif
endfunction


""""""""""""""""""""""""""""""""""""""""""""""
"" Define function SwitchToBuf(filename)

""""""""""""""""""""""""""""""""""""""""""""""
function! SwitchToBuf(filename)
    "let fullfn = substitute(a:filename, "^\\~/", $HOME . "/", "")
    " find in current tab
    let bufwinnr = bufwinnr(a:filename)
    if bufwinnr != -1
        exec bufwinnr . "wincmd w"
        return
    else
        " find in each tab
        tabfirst
        let tab = 1
        while tab <= tabpagenr("$")
            let bufwinnr = bufwinnr(a:filename)
            if bufwinnr != -1
                exec "normal " . tab . "gt"
                exec bufwinnr . "wincmd w"
                return
            endif
            tabnext
            let tab = tab + 1
        endwhile
        " not exist, new tab
        exec "tabnew " . a:filename
    endif
endfunction


""""""""""""""""""""""""""""""""""""""""""""""
"Fast edit vimrc

""""""""""""""""""""""""""""""""""""""""""""""
if MySys() == 'linux'
    "Fast reloading of the .vimrc
    map <silent> <leader>ss :source ~/.vimrc<cr>
    "Fast editing of .vimrc
    map <silent> <leader>ee :call SwitchToBuf("~/.vimrc")<cr>
    "When .vimrc is edited, reload it
    "autocmd! bufwritepost .vimrc source ~/.vimrc
elseif MySys() == 'windows'
    " Set helplang
    set helplang=cn
    "Fast reloading of the _vimrc
    "Not in Cygwin environment
    map <silent> <leader>ss :source C:/Program\ Files/Vim/_vimrc<cr>
    "Fast editing of _vimrc
    "Not in Cygwin environment
    map <silent> <leader>ee :call SwitchToBuf("C:/Program\ Files/Vim/_vimrc")<cr>
    "When _vimrc is edited, reload it
    "autocmd! bufwritepost _vimrc source ~/_vimrc  " What does the line mean?
endif


set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ==> For Windows version
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if MySys() == 'windows'
    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin
endif


set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and fonts
""""""""""""""""""""""""""""""""""""""""""""""
syntax enable
syntax on

set t_Co=256 "number of Colors"
set background=dark " This may not effect in VIM; It's background will be white, though.
" colorscheme desert
"colorscheme molokai

set number


" hilight function name
autocmd BufNewFile,BufRead * :syntax match cfunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^()]*)("me=e-2
autocmd BufNewFile,BufRead * :syntax match cfunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>\s*("me=e-1

hi cfunctions ctermfg=81 "(这一行就是给函数名加颜色的)

""""""""""""""""""""""""""""""""""""""""""""""
" change color in Gvim
""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")

endif

""""""""""""""""""""""""""""""""""""""""""""""
" ==> Change color in Normal Vim
""""""""""""""""""""""""""""""""""""""""""""""
if !has("gui_running")
    highlight Normal ctermfg=grey ctermbg=black "Set Vim's background color and foreground color
endif 




" set cursorline && higtligt current line
set cursorline
:hi CursorLine cterm=underline " ctermbg=gray ctermfg=white guibg=gray guifg=white ""highlight currentline-horizontal
" :hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
" :nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>


""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
"set expandtab "Not good for Makefile filetype

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 space keys
set shiftwidth=4
set tabstop=4

set ai " Auto indent
set si "Smart indent
set wrap " Wrap lines


""""""""""""""""""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""""""""""""""""""
" Always show the status line and row=2; One is statusline ,second is the
" command line
set laststatus=2 

" Format the status line
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %1
set statusline=[%F]%y%r%m%*%=[%{&fileencoding}][Line:%l/%L,Column:%c][%p%%]

set ruler  " 在编辑过程中，在右下角显示光标位置的状态行


"--------------------------------------------------------------------------------
" 窗口操作的快捷键
"--------------------------------------------------------------------------------
nmap wv     <C-w>v     " 垂直分割当前窗口
nmap wc     <C-w>c     " 关闭当前窗口
nmap ws     <C-w>s     " 水平分割当前窗口



"--------------------------------------------------------------------------------
" close Gvim's toolbar, menu bar, scroll bar
"--------------------------------------------------------------------------------
if has("gui_running")
    set guioptions-=m "remove menu bar
    set guioptions-=T "remove tool bar
    set guioptions-=r "remove right-hand scroll bar
    set guioptions-=l "remove left-hand scroll bar
endif



""""""""""""""""""""""""""""""
" Tag list (ctags)
""""""""""""""""""""""""""""""
if MySys() == "windows"                "设定windows系统中ctags程序的位置
    let Tlist_Ctags_Cmd = 'ctags'
elseif MySys() == "linux"              "设定linux系统中ctags程序的位置
    let Tlist_Ctags_Cmd = '/usr/bin/ctags'
endif

let Tlist_Show_One_File = 1            "不同时显示多个文件的tag，只显示当前文件的
let Tlist_Exit_OnlyWindow = 1          "如果taglist窗口是最后一个窗口，则退出vim
let Tlist_Use_Right_Window = 1         "在右侧窗口中显示taglist窗口

map <silent> <F3> :TlistToggle<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "left" "在左侧
let NERDTreeShowHidden=0
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35

" open and close NERDTREEWINDOW
map <leader>nn :NERDTreeToggle<cr>  
map <silent> <F2> :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark
map <leader>nf :NERDTreeFind<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vimgrep, Quickfix, Makeprg
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType c,cpp  map <buffer> <leader><space> :w<cr>:make<cr>
nmap <leader>cn :cn<cr>
nmap <leader>cp :cp<cr>
nmap <leader>cw :cw 10<cr> 
" 编译后，如有错误则打开quickfix窗口。（光标仍停留在源码窗口）
" If error occur after compiling, then the quickfix window is opened automatically.
" the cursor is still in the source window.
"
" 注意：需要开启netsting autocmd
" Note: netsting autocmd should be opened.
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow


" 在我的vimrc中，定义下面的键映射，利用它可以在当前文件中快速查找光标下的单词
nmap <leader>lv :lv /<c-r>=expand("<cword>")<cr>/ %<cr>:lw<cr>
