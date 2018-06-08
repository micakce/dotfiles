let mapleader = " "

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'JamshedVesuna/vim-markdown-preview'

Plug 'drewtempelmeyer/palenight.vim'

" Make sure you use single quotes "{{{
Plug 'vim-airline/vim-airline'
" set laststatus=2
" let g:airline_theme='murmur'
" set t_Co=256
" let g:airline_powerline_fonts = 1
" let g:airline_symbols.maxlinenr ='' "}}}

Plug 'vim-airline/vim-airline-themes' "{{{
let g:airline_theme='murmur'
set laststatus=2
set t_Co=256
if !exists('g:airline_symbols') "{{{
    let g:airline_symbols = {}
endif
let g:airline_symbols.maxlinenr ='' "}}}
" let g:airline_powerline_fonts = 1
" let g:airline#extensions#tabline#left_alt_sep = ''
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#left_sep = '⦒' "}}}


Plug 'easymotion/vim-easymotion'
map f <Leader><Leader>f
map F <Leader><Leader>F

Plug 'junegunn/vim-easy-align' "{{{
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
"}}}

Plug 'christoomey/vim-tmux-navigator'
nmap <Leader>a <c-a>

Plug 'Yggdroot/indentLine'
let g:indentLine_color_term = 8
let g:indentLine_char = '┊' "↕  ⦚ ≀ ⟩ ⦂⦊ ⦒⫶ ⚡ ϟ ¦ ┋ ⦙ ░┊

Plug 'jiangmiao/auto-pairs'
" let g:AutoPairsShortcutBackInsert = 'ß'
" let g:AutoPairsShortcutToggle = 'ŧ'
" let g:AutoPairsShortcutFastWrap = 'ł'
" let g:AutoPairsShortcutJump = ''


Plug 'tpope/vim-commentary' "{{{
" autocmd Filetype python setlocal commentstring=#'\ %s'
vmap <leader>yc s"}}}<C-c>_PA"{{{
noremap <leader>ysc {jA "{{{<C-c>}kA "}}}<C-c>
noremap <leader>dsc di{"_dipP "}}}o<C-c>

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
" Plug 'tpope/vim-vinegar'

" Plug 'scrooloose/nerdtree'
" Plug 'jistr/vim-nerdtree-tabs'
" nmap <Leader>nt <plug>NERDTreeTabsToggle<CR>
" let g:NERDTreeWinPos = "right"

Plug 'ctrlpvim/ctrlp.vim' "{{{
let g:ctrlp_max_height = 20
let g:ctrlp_show_hidden = 1
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=*/coverage/*
set wildmenu
set wildmode=list:longest,full "}}}

Plug 'scrooloose/syntastic' "{{{
" let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute " ,"trimming empty <", "unescaped &" , "lacks \"action", "is not recognized!", "discarding unexpected"]
" let g:syntastic_python_checkers=['flake8']
" let g:syntastic_html_checkers=['jshint']
" let g:syntastic_javascript_checkers=['eslint']
" let g:syntastic_check_on_open = 1
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_wq = 0 "}}}

Plug 'ervandew/supertab' "{{{
" autocmd FileType javascript let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
" let g:UltiSnipsExpandTrigger="<C-l>"
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>" "}}}


source $HOME/dotfiles/vim/autocompletion.vimrc


Plug 'wellle/targets.vim' "Argument-Text-Object
Plug 'michaeljsmith/vim-indent-object'
Plug 'mattn/emmet-vim'

" All of your Plugs must be added before the following line
call plug#end()            " required

filetype plugin indent on    " required

"" Misc
"" File Navegation Netrw
nnoremap <Leader>E :Ex<CR>
runtime macros/matchit.vim


nnoremap <Leader># *N
nnoremap <Leader>gib cib<c-c>"_cc<c-c>P
inoremap jj <esc>
inoremap jk <esc>
noremap <Leader>= mmgg=G'mz.
noremap <Leader>scl _iconsole.log(<c-c>A)<c-c>F;xA;<c-c>
inoremap ,cl console.log();<c-c>hi
noremap <Leader>tn :tabnew<CR>
noremap <Leader>ev :bel vsplit $MYVIMRC<CR>
noremap <Leader>evh :e $MYVIMRC<CR>
noremap <Leader>sv :source $MYVIMRC<CR>
noremap <Leader>br mm:s/\S/&\r/g<CR>:nohl<CR>dd'm
noremap <Leader>h :tabprevious<CR>
noremap <Leader>l :tabnext<CR>
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o ""autocomment insertion
nnoremap <Leader><CR> i<CR><c-c>
nnoremap <Leader>o Go
" noremap <Leader>gu<CR> :! gulp && clear && node public/dist/%:t<CR>
inoremap <C-f> <C-c>A
set showcmd
" Command Mode
noremap! <C-K> <up>
noremap! <C-J> <down>

" automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

" Mouse and backspace
set mouse=a " on OSX press ALT and click
set bs=2 " make backspace behave like normal again
noremap <C-n> :nohl<CR>
" vnoremap <C-n> :nohl<CR>

" Quicksave command
nnoremap  <Leader>u :update<CR>

" Quick quit command
nnoremap <Leader>q :quit<CR>
nnoremap <Leader>Q :q!<CR>
nnoremap <Leader>Qa :qa!<CR>
nnoremap <Leader>wq :wq<CR>

map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" map sort function to a key
vnoremap <Leader>s :sort<CR>

"Easy block indetentation
vnoremap < <gv
vnoremap > >gv

" Show whitespace MUST be inserted BEFORE the colorscheme command
" autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
" au InsertLeave * match ExtraWhitespace /\s\+$/

" Color scheme mkdir -p ~/.vim/colors && cd ~/.vim/colors wget -O
" color my_html
" setlocal spell spelllang=en_us
hi SpellBad ctermbg=yellow ctermfg=black
hi SpellCap ctermbg=yellow ctermfg=black
set cursorline
" set cursorcolumn
hi Cursorline cterm=none ctermbg=235
" hi Cursorcolumn ctermbg=235
" autocmd BufEnter *.html colorscheme my_html
" au BufEnter * colorscheme wombat256mod

" Showing line numbers and length
set number " show line numbers
set relativenumber "show relative line numbers
set tw=79 " width of document (used by gd)
set nowrap " don't automatically wrap on load
set fo-=t " don't automatically wrap text when typing
set colorcolumn=80
highlight colorcolumn ctermbg=233

" Useful settings
set history=700
set undolevels=700

" " Real programmers don't use TABs but spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab

" Make search case insensitive
set hlsearch
set incsearch
set ignorecase
set smartcase

" Disable stupid backup and swap files - they trigger too many events
" for file system watchers
set nobackup
set nowritebackup
set noswapfile

" Better navigating through omnicomplete option list
" See http://stackoverflow.com/questions/2170023/how-to-map-keys-for-popup-menu-in-vim

""Move Lines
nnoremap mj :normal! ddp==<CR>
nnoremap mk :<c-u> execute "normal! dd" . v:count . "kP=="<CR>
vnoremap mj :m'>+<CR>gv=gv
vnoremap mk :m-2<CR>gv=gv

" Better copy/paste
set pastetoggle=<F10>
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
noremap <Leader>dd dd
noremap <Leader>d d
noremap <LeaderD> D
noremap c "_c
noremap cc "_cc
noremap dd "_dd
noremap d "_d
noremap D "_D
noremap x "_x
noremap ml xp

" Better search
noremap <F3> :vimgrep //j **/*<left><left><left><left><left><left><left>
augroup myvimrc
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l*    lwindow
augroup END

augroup XML
    autocmd!
    autocmd FileType xml let g:xml_syntax_folding=1
    autocmd FileType xml setlocal foldmethod=syntax
    autocmd FileType xml :syntax on
    autocmd FileType xml setlocal tabstop=2 softtabstop=2  shiftwidth=2
    autocmd FileType xml :%foldopen!
augroup END

function! EnterOrIndentTag()
    let line = getline(".")
    let col = getpos(".")[2]
    let before = line[col-2]
    let after = line[col-1]
    if before == ">" && after == "<"
        return "\<Enter>\<C-o>==\<C-o>O"
    endif
    return "\<Enter>"
endfunction
inoremap <expr> <Enter> EnterOrIndentTag()


"" FoldText
set foldmethod=marker
" let g:vimsyn_folding='af'
" let g:tex_fold_enabled=1
" let g:xml_syntax_folding = 1
" let g:clojure_fold = 1
" let ruby_fold = 1
" let perl_fold = 1
" let perl_fold_blocks = 1
" set foldenable
" set foldlevel=0
" set foldlevelstart=0
" " specifies for which commands a fold will be opened
" set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo

" nnoremap <silent> zr zr:<c-u>setlocal foldlevel?<CR>
" nnoremap <silent> zm zm:<c-u>setlocal foldlevel?<CR>

" nnoremap <silent> zR zR:<c-u>setlocal foldlevel?<CR>
" nnoremap <silent> zM zM:<c-u>setlocal foldlevel?<CR>

" " Change Option Folds
nnoremap zi  :<c-u>call <SID>ToggleFoldcolumn(1)<CR>
nnoremap coz :<c-u>call <SID>ToggleFoldcolumn(0)<CR>
nmap     cof coz

function! s:ToggleFoldcolumn(fold)
    if &foldcolumn
        let w:foldcolumn = &foldcolumn
        silent setlocal foldcolumn=0
        if a:fold | silent setlocal nofoldenable | endif
    else
        if exists('w:foldcolumn') && (w:foldcolumn!=0)
            silent let &l:foldcolumn=w:foldcolumn
        else
            silent setlocal foldcolumn=4
        endif
        if a:fold | silent setlocal foldenable | endif
    endif
    setlocal foldcolumn?
endfunction


function! Compile() "{{{
    if  &filetype=="html"
        silent !clear
        execute "!chromium-browser " . bufname("%")
    elseif &filetype=="javascript"
        silent !clear
        execute "!nodejs " . bufname("%")
    endif
endfunction
nnoremap ¢ :call Compile()<CR> "}}}

function! s:rtrim(line) "{{{
    return substitute(a:line, '\s*$', '', '')
endfunction "}}}

function! s:find_rside_commentpos(lnum) "{{{
    let line = getline(a:lnum)
    let col = stridx(line, ';')
    while col != -1 &&
                \ synIDattr(synID(a:lnum, col, 1), "name") =~ "String"
        let col = stridx(line, ';', col + 1)
    endwhile
    return col
endfunction "}}}

function! s:LISP_close_parens(lnum) "{{{
    let save_cursor = getpos(".")

    call cursor(a:lnum, col('$'))
    let unbalanced = searchpair('(', '', ')', 'rmbcW',
                \ "synIDattr(synID(line('.'), col('.'), 0), 'name') =~? ".
                \ "'\\(Comment\\|String\\)'")
    if unbalanced > 0
        let line = getline(a:lnum)
        let unbalanced_str = repeat(')', unbalanced)
        let col = s:find_rside_commentpos(a:lnum)
        if col != -1
            let before_comment = strpart(line, 0, col)
            let wsp_cnt = strlen(before_comment) - strlen(s:rtrim(before_comment))
            let wsp_str = repeat(' ', wsp_cnt)
            let comment = strpart(line, col)
            call setline(a:lnum,
                        \ s:rtrim(before_comment).unbalanced_str.wsp_str.comment)
        else
            let line = s:rtrim(line).unbalanced_str
            call setline(a:lnum, line)
        endif
    endif

    call setpos(".", save_cursor)
endfunction "}}}

command! LISPCloseParens call <SID>LISP_close_parens(line('.'))
map <Leader>) :LISPCloseParens<CR>
map <Leader>( :LISPCloseParens<CR>

set background=dark
colorscheme palenight
set clipboard=unnamed
