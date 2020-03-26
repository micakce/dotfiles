let mapleader = " "

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')

" TO DELETE
" Plug 'mcchrish/nnn.vim'
" Plug 'mxw/vim-jsx'
" let g:vim_jsx_pretty_highlight_close_tag=1
" let g:vim_jsx_pretty_colorful_config=1
" Plug 'JamshedVesuna/vim-markdown-preview' "sudo apt install xdotool
" Plug 'joeyespo/grip'
" let vim_markdown_preview_hotkey='<leader>om'
" let vim_markdown_preview_toggle=0
" let vim_markdown_preview_github=1
" let vim_markdown_preview_pandoc=0

Plug 'godlygeek/tabular'
" Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }


Plug 'pangloss/vim-javascript'

Plug 'MaxMEllon/vim-jsx-pretty'



Plug 'drewtempelmeyer/palenight.vim'

Plug 'vim-airline/vim-airline' "{{{
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
let g:airline_symbols.maxlinenr ='|' "}}}
" let g:airline_powerline_fonts = 1
" let g:airline#extensions#tabline#left_alt_sep = ''
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#left_sep = '⦒' "}}}


Plug 'easymotion/vim-easymotion'
map f <Leader><Leader>f
map F <Leader><Leader>F
map t <Leader><Leader>t
map T <Leader><Leader>T

Plug 'junegunn/vim-easy-align' "{{{
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
"}}}

Plug 'christoomey/vim-tmux-navigator'
" nmap <Leader>a <c-a>

Plug 'Yggdroot/indentLine'
let g:indentLine_color_term = 8
let g:indentLine_char = '┊' "↕  ⦚ ≀ ⟩ ⦂⦊ ⦒⫶ ⚡ ϟ ¦ ┋ ⦙ ░┊

Plug 'jiangmiao/auto-pairs'
" let g:AutoPairsShortcutBackInsert = 'ß'
" let g:AutoPairsShortcutToggle = 'ŧ'
" let g:AutoPairsShortcutFastWrap = 'ł'
" let g:AutoPairsShortcutJump = ''


Plug 'tpope/vim-commentary' "{{{
autocmd Filetype matlab setlocal commentstring=%\ %s
" autocmd Filetype python setlocal commentstring=#'\ %s'
vmap <leader>yc s"}}}<C-c>_PA"{{{
noremap <leader>ysc {jA "{{{<C-c>}kA "}}}<C-c>
noremap <leader>dsc di{"_dipP "}}}o<C-c>

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
" Plug 'tpope/vim-vinegar'

Plug 'tpope/vim-dadbod'

" Plug 'zxqfl/tabnine-vim'


Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" let g:fzf_buffers_jump = 1
noremap <c-p> :Files<CR>
noremap <c-f> :Find<CR>
noremap <c-b> :Buffers<CR>
inoremap <Leader><c-f> <plug>(fzf-complete-path)
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(
            \   <q-args>,
            \   fzf#vim#with_preview(),
            \   <bang>0
            \ )

function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

command! -bang -nargs=* GGrep
            \ call fzf#vim#grep(
            \   'git grep --line-number '.shellescape(<q-args>), 0,
            \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)


command! -bang -nargs=* Rg
            \ call fzf#vim#grep(
            \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
            \   fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* Find
            \ call fzf#vim#grep(
            \ 'rg
            \ --column
            \ --line-number
            \ --no-heading
            \ --fixed-strings
            \ --ignore-case
            \ --no-ignore
            \ --hidden
            \ --follow
            \ --color "always"
            \ --glob "!{.git,node_modules,package-lock.json,build}" '
            \   .shellescape(<q-args>), 1,
            \   <bang>0 ? fzf#vim#with_preview('up:50%')
            \           : fzf#vim#with_preview('right:50%:hidden', '?'),
            \   <bang>0)

" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options

Plug 'jremmen/vim-ripgrep'


" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'
" source $HOME/dotfiles/vim/autocompletion.vimrc
Plug 'neoclide/coc.nvim', {'branch': 'release'}
set hidden
set cmdheight=2
set updatetime=300
set signcolumn=yes
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> ñ coc#refresh()

" ### CocInstall coc-snippets ###
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)
" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)
" Use <C-j> for jump to next placeholder, it's default of coc.nvim
" let g:coc_snippet_next = '<c-j>'
" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
" let g:coc_snippet_prev = '<c-k>'
" Use <C-j> for both expand and jump (make expand higher priority.)
" imap <C-j> <Plug>(coc-snippets-expand-jump)

source $HOME/dotfiles/vim/LISPCloseParens.vimrc
source $HOME/dotfiles/vim/foldSetting.vimrc

Plug 'dense-analysis/ale'
let g:ale_enabled = 0
let g:ale_fix_on_save = 1
" let g:airline#extensions#ale#enabled = 1
" let g:ale_set_highlights = 0
" highlight clear ALEErrorSign
" highlight clear ALEWarningSign
" let g:ale_java_javac_classpath = '~/studying/java_101/authorizeTransactions/lib/org/json/'
" let g:ale_java_javalsp_executable =
"             \ {
"             \   'java': {
"             \     'externalDependencies': [
"             \       '~/studying/java_101/authorizeTransactions/lib/json-20190722.jar'
"             \     ],
"             \     'classPath': [
"             \       '~/studying/java_101/authorizeTransactions/lib/json-20190722.jar'
"             \     ]
"             \   }
"             \ }
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_fixers = {
            \   '*': ['remove_trailing_lines', 'trim_whitespace'],
            \   'javascript': ['eslint'],
            \   'java': ['google_java_format'],
            \}

Plug 'wellle/targets.vim' "Argument-Text-Object
Plug 'michaeljsmith/vim-indent-object'

Plug 'alvan/vim-closetag'
let g:closetag_filetypes = 'html,xhtml,phtml,javascript'

Plug 'mattn/emmet-vim'
" imap ,<Tab> <C-y>,
" imap ,j <C-y>j


Plug 'aklt/plantuml-syntax'
Plug 'tyru/open-browser.vim'
Plug 'weirongxu/plantuml-previewer.vim'
" Plug 'scrooloose/vim-slumlord'

" Plug 'mustache/vim-mustache-handlebars'
" " Enable/disable abbreviations {{if => {{#if _}}{{/if}}
" let g:mustache_abbreviations = 0
" " Enable/disable object operatos ie, ae (inside/around element), enabled bydefault
" let g:mustache_operators = 0
Plug 'tweekmonster/django-plus.vim'

" All of your Plugs must be added before the following line
call plug#end()            " required

filetype plugin indent on    " required

"" File Navegation Netrw
"" Misc

" tree-view
let g:netrw_liststyle = 3
let g:netrw_banner = 0

" noremap  i<CR><c-c>
noremap <silent> <Leader>tw :%s,\s*$,,g<CR>'':nohl<CR>
set switchbuf+=usetab,newtab
autocmd BufEnter *.hbs :set ft=html
com! FormatJSON %!python3 -m json.tool
noremap mew xwP
nnoremap <Leader>cu :set undoreload=0<CR> :edit<CR>
nnoremap <Leader>E :Ex<CR>
runtime macros/matchit.vim
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
" nnoremap  i<CR><c-c>
nnoremap <Leader>o Go
" noremap <Leader>gu<CR> :! gulp && clear && node public/dist/%:t<CR>
inoremap <C-f> <C-c>A
set showcmd
" Command Mode
" noremap! <C-J> <down>
" noremap! <C-K> <up>

" automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %
" Mouse and backspace
set mouse=a " on OSX press ALT and click
set bs=2 " make backspace behave like normal again
noremap <silent> <C-n> :nohl<CR>
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
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au InsertLeave * match ExtraWhitespace /\s\+$/
autocmd ColorScheme * highlight fLiteral ctermfg=45
" " This is to match brackets, messess up jsx syntax
" au InsertLeave * match fLiteral /{.*}/

" Color scheme mkdir -p ~/.vim/colors && cd ~/.vim/colors wget -O
" color my_html
" Activa and desactivate spelling
noremap <F8> :call Spelling()<CR>
function! Spelling()
    if  &spell
        execute "setlocal spell!"
        echomsg "Spelling is off"
    else
        execute "setlocal spell spelllang=en_us"
        echomsg "Spelling is on"
    endif
endfunction
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
vnoremap j :m'>+<CR>gv=gv
vnoremap k :m-2<CR>gv=gv
nnoremap j :normal! ddp==<CR>
nnoremap k  :<c-u> execute "normal! dd" . v:count . "kP=="<CR>

" Better copy/paste
set clipboard=unnamedplus
set pastetoggle=<F10>
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
noremap <Leader>dd "_dd
noremap <Leader>d "_d
noremap <Leader>D "_D
noremap <Leader>c "_c
noremap <Leader>cc "_cc
noremap <Leader>x "_x

" Better search
" noremap <F3> :vimgrep //j **/*<left><left><left><left><left><left><left>
function! Vimgrep()
    call inputsave()
    let search = input('Enter search: ')
    call inputrestore()
    execute "vimgrep/" . search . "/j **/*"
endfunction
noremap <F3> :call Vimgrep()<CR>

augroup myvimrc
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l*    lwindow
augroup END


augroup PYTHON
    autocmd!
    autocmd FileType python nnoremap ¢ :w !python3 %<CR>
augroup END

augroup XML
    autocmd!
    autocmd FileType xml let g:xml_syntax_folding=1
    autocmd FileType xml setlocal foldmethod=syntax
    autocmd FileType xml :syntax on
    autocmd FileType xml setlocal tabstop=2 softtabstop=2  shiftwidth=2
    autocmd FileType xml :%foldopen!
augroup END

augroup javascript
    autocmd!
    autocmd FileType javascript setlocal foldmethod=syntax
                \ tabstop=2 softtabstop=2  shiftwidth=2
augroup END

augroup java
    autocmd!
    autocmd FileType java map <F5> :call CompileJava()<CR>
    " autocmd FileType java nnoremap ¢ :w !javac %<CR>
    " autocmd FileType java nnoremap <F5> :!java -cp %:p:h %:t:r<CR>
augroup END

func! CompileJava()
    exec "!javac %"
    exec "!time java -cp %:p:h %:t:r"
endfunc

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

" function! Compile() "{{{
"     if  &filetype=="html"
"         silent !clear
"         execute "!google-chrome " . bufname("%")
"     elseif &filetype=="javascript"
"         silent !clear
"         execute "!nodejs " . bufname("%")
"     elseif &filetype=="python"
"         silent !clear
"         execute "!python3 %"
"     endif
" endfunction
" nnoremap ¢ :call Compile()<CR> "}}}


set background=dark
colorscheme palenight
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
