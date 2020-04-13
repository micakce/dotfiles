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

Plug 'godlygeek/tabular'
" Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
let g:mkdp_auto_close = 0
noremap <leader>mp :MarkdownPreview<CR>


Plug 'pangloss/vim-javascript'

Plug 'MaxMEllon/vim-jsx-pretty'

Plug 'drewtempelmeyer/palenight.vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes' "{{{
let g:airline_theme='murmur'
set laststatus=2
set t_Co=256
if !exists('g:airline_symbols') "{{{
    let g:airline_symbols = {}
endif
let g:airline_symbols.maxlinenr ='|' "}}}
"}}}

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

Plug 'Yggdroot/indentLine'
let g:indentLine_color_term = 8
let g:indentLine_char = '┊'

Plug 'jiangmiao/auto-pairs'
" let g:AutoPairsShortcutBackInsert = 'ß'
" let g:AutoPairsShortcutToggle = 'ŧ'
" let g:AutoPairsShortcutFastWrap = 'ł'
" let g:AutoPairsShortcutJump = ''


Plug 'tpope/vim-commentary' "{{{
autocmd Filetype matlab setlocal commentstring=%\ %s

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
" Plug 'tpope/vim-vinegar'

Plug 'tpope/vim-dadbod'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
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
command! -nargs=* -bang Find call RipgrepFzf(<q-args>, <bang>0)

command! -bang -nargs=* Rg
            \ call fzf#vim#grep(
            \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
            \   fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* Ffind
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

Plug 'jremmen/vim-ripgrep'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
set hidden
set cmdheight=2
set updatetime=300
set signcolumn=yes

" set statusline^=%{coc#status()}
" Disable vim-airline integration:
" let g:airline#extensions#coc#enabled = 0
" " Change error symbol:
" let airline#extensions#coc#error_symbol = 'Error:'
" " Change warning symbol:
" let airline#extensions#coc#warning_symbol = 'Warning:'
" " Change error format:
" let airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'
" " Change warning format:
" let airline#extensions#coc#stl_format_warn = '%W{[%w(#%fw)]}'

" Specify a directory for plugins
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

Plug 'honza/vim-snippets'
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

Plug 'wellle/targets.vim' "Argument-Text-Object
Plug 'michaeljsmith/vim-indent-object'

Plug 'alvan/vim-closetag'
let g:closetag_filetypes = 'html,xhtml,phtml,javascript'

Plug 'mattn/emmet-vim'

Plug 'aklt/plantuml-syntax'

" " Check later
" Plug 'haya14busa/vim-asterisk'
Plug 'haya14busa/is.vim'

Plug 'vimwiki/vimwiki'
set nocompatible
filetype plugin on
syntax on
let g:vimwiki_folding = 'syntax'
if !exists('wiki')
    let wiki={}
    let wiki.path= "~/dotfiles/vimwiki/wiki"
    let wiki.path_html= "~/dotfiles/vimwiki/wiki_html"
    let wiki.syntax= "markdown"
    let wiki.ext= ".md"
    " let wiki.template_path ="~/dotfiles/vimwiki/wiki/templates"
    " let wiki.template_default="default"
    let wiki.template_ext=".html"
endif
let g:vimwiki_list = [wiki]
" let g:vimwiki_ext2syntax = {'.md': 'markdown',
"             \ '.mkd': 'markdown',
            " \ '.wiki': 'media'}

" All of your Plugs must be added before the following line
call plug#end()            " required
filetype plugin indent on    " required


"" File Navegation
let g:netrw_liststyle = 3
let g:netrw_banner = 0

" Miscelaneos
noremap <silent> <Leader>tw :%s,\s*$,,g<CR>'':nohl<CR>
set switchbuf+=usetab,newtab
autocmd BufEnter *.hbs :set ft=html
com! FormatJSON %!python3 -m json.tool
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
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o ""autocomment insertion
nnoremap <Leader>o Go
inoremap <C-f> <C-c>A
set showcmd

" Mouse and backspace
set mouse=a " on OSX press ALT and click
set bs=2 " make backspace behave like normal again
noremap <silent> <C-n> :nohl<CR>

" Quicksave command
nnoremap  <Leader>u :update<CR>

" Quick quit command
nnoremap <Leader>q :quit<CR>
nnoremap <Leader>Q :q!<CR>
nnoremap <Leader>Qa :qa!<CR>

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

" Activa and desactivate spelling
function! Spelling()
    if  &spell
        execute "setlocal spell!"
        echomsg "Spelling is off"
    else
        execute "setlocal spell spelllang=en_us"
        echomsg "Spelling is on"
    endif
endfunction
noremap <F8> :call Spelling()<CR>

hi SpellBad ctermbg=yellow ctermfg=black
hi SpellCap ctermbg=yellow ctermfg=black

set cursorline
" set cursorcolumn
hi Cursorline cterm=none ctermbg=235

" Showing line numbers and length
set number " show line numbers
set relativenumber "show relative line numbers
set nowrap " don't automatically wrap on load
" set fo-=t " don't automatically wrap text when typing
set tw=89 " width of document (used by gd)
set colorcolumn=90
highlight colorcolumn ctermbg=233

" Useful settings
set history=700
set undolevels=700

" Real programmers don't use TABs but spaces
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
