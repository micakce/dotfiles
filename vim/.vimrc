" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" VimPlug: Auto install vimplug, plugin manager
" - Avoid using standard Vim directory names like 'plugin'
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } } " MarkDownPreview
Plug 'drewtempelmeyer/palenight.vim' " My favorite colorscheme, aparently
Plug 'vim-airline/vim-airline' " VimAirline
Plug 'vim-airline/vim-airline-themes'
Plug 'easymotion/vim-easymotion' " VimEasyMotion
Plug 'christoomey/vim-tmux-navigator'
Plug 'Yggdroot/indentLine' " IndentLine
Plug 'jiangmiao/auto-pairs' " Automatic brackets and quotes insert
" TPOPE: ¡CAPO!
Plug 'tpope/vim-repeat' " Mini macros dot repeat
Plug 'tpope/vim-surround' " Object-text surround commands
Plug 'tpope/vim-dadbod' " Connect with databases
Plug 'tpope/vim-commentary' " VimCommentary
" JUNEGUNN: !PUTO CRACK!
Plug 'junegunn/vim-easy-align' " VimEasyAlign
Plug 'junegunn/vim-slash' " Slash
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } "FZF
Plug 'junegunn/fzf.vim'
Plug 'jremmen/vim-ripgrep'
Plug 'neoclide/coc.nvim', {'branch': 'release'} "COC
Plug 'honza/vim-snippets' " VimSnippets
Plug 'wellle/targets.vim' " Argument based text object
Plug 'michaeljsmith/vim-indent-object' " Indent based text object
Plug 'mattn/emmet-vim' "HTML
Plug 'vimwiki/vimwiki' "VimWiki
Plug 'airblade/vim-gitgutter' "GitGutter
call plug#end()            " required
filetype plugin indent on    " required


" Who is the boss key?
let mapleader = " "

colorscheme palenight

"MarkdDownPreview: Needs neovim or Vim version >= 8.2
" Dont close the preview when changing buffer
let g:mkdp_auto_close = 0
noremap <leader>mp :MarkdownPreview<CR>

" VimAirline: Nice status bar
set laststatus=2
set t_Co=256
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='murmur'

" VimEasyMotion: Jump cursor wherever you want
map f <Leader><Leader>f
map F <Leader><Leader>F
map t <Leader><Leader>t
map T <Leader><Leader>T

" IndentLine: Indent guide lines
let g:indentLine_color_term = 8
let g:indentLine_char = '┊'

" VimCommentary: Especific file comment syntax
autocmd Filetype matlab setlocal commentstring=%\ %s

"            JUNEGUNN: ¡PUTO CRACK!
" VimEasyAlign: Best aligment plugin ever
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Slash: Improved search highlighting
if has('timers')
    " Blink 2 times with 50ms interval
    noremap <expr> <plug>(slash-after) 'zz'.slash#blink(2, 45)
else
    noremap <plug>(slash-after) zz
endif

"            FZF: Everything fuzzy finder
" General_options:
" Open in a new full window
let g:fzf_layout = { 'window': 'enew' }
" hide status bar
autocmd! FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" Files: Find fies in project with fzf
command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, fzf#vim#with_preview("down:50%"), <bang>0)

"Find: Find files by content
function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec, "down:50%"), a:fullscreen)
endfunction
command! -nargs=* -bang Find call RipgrepFzf(<q-args>, <bang>0)

" Mappings:
noremap <c-p> :Files<CR>
noremap <c-f> :Find<CR>
noremap <c-b> :Buffers<CR>
inoremap <Leader><c-f> <plug>(fzf-complete-path)
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

" COC: LSP auto-completion engine
set hidden
set updatetime=300
set signcolumn=yes
" set completeopt+=noselect
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <esc>r coc#refresh()
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
" Remap for rename current word
nmap <F2> <Plug>(coc-rename)

" coc config
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-tsserver',
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-json',
  \ ]
" " from readme
" " if hidden is not set, TextEdit might fail.
" set hidden " Some servers have issues with backup files, see #649 set nobackup set nowritebackup
" Better display for messages set cmdheight=2 " You will have bad experience for diagnostic messages when it's default 4000.
" set updatetime=300
" " don't give |ins-completion-menu| messages.
" set shortmess+=c
" " always show signcolumns
" set signcolumn=yes
" VimSnippets: Useful snippets
" " ### CocInstall coc-snippets ###
" " Use <C-l> for trigger snippet expand.
" imap <C-l> <Plug>(coc-snippets-expand)
" " Use <C-j> for select text for visual placeholder of snippet.
" vmap <C-j> <Plug>(coc-snippets-select)
" " Use <C-j> for jump to next placeholder, it's default of coc.nvim
" " let g:coc_snippet_next = '<c-j>'
" " Use <C-k> for jump to previous placeholder, it's default of coc.nvim
" " let g:coc_snippet_prev = '<c-k>'
" " Use <C-j> for both expand and jump (make expand higher priority.)
" " imap <C-j> <Plug>(coc-snippets-expand-jump)

" VimWiki: Documentation tool
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

" Explorer: File Navigation
let g:netrw_liststyle = 3
let g:netrw_banner = 0

" #TODO clean up the rest from here on

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
noremap <Leader>ev :tabnew $MYVIMRC<CR>
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
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" " This is to match brackets, messess up jsx syntax
" au InsertLeave * match fLiteral2 /f\('\|"\).*\({[^}]*}\).*\('\|"\)/;/{[^}]*}/
" au! InsertLeave * match fLiteral /f\('\|"\).*\({[^}]*}\).*\('\|"\)/\2

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
" hi SpellBad ctermbg=yellow ctermfg=black
" hi SpellCap ctermbg=yellow ctermfg=black


" set cursorcolumn
set cursorline
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
    autocmd ColorScheme * highlight fLiteral ctermfg=133
    autocmd BufRead,BufEnter,InsertLeave *.py match fLiteral /{[^}]*}/
    autocmd FileType python set foldmethod=indent
augroup END

augroup XML
    autocmd!
    autocmd FileType xml let g:xml_syntax_folding=1
    autocmd FileType xml setlocal foldmethod=syntax
    autocmd FileType xml setlocal tabstop=2 softtabstop=2  shiftwidth=2
    autocmd FileType xml :%foldopen!
augroup END

augroup JAVASCRIPT
    autocmd!
    autocmd FileType javascript setlocal foldmethod=syntax
                \ tabstop=2 softtabstop=2  shiftwidth=2
augroup END

augroup YAML
    autocmd!
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
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

function! Compile() "{{{
    if  &filetype=="html"
        silent !clear
        execute "!google-chrome " . bufname("%")
    elseif &filetype=="javascript"
        silent !clear
        execute "!nodejs " . bufname("%")
    elseif &filetype=="python"
        silent !clear
        execute "w | !clear & python3 %"
    endif
endfunction
nnoremap ¢ :call Compile()<CR>
"}}}


source $HOME/dotfiles/vim/LISPCloseParens.vimrc
source $HOME/dotfiles/vim/foldSetting.vimrc
set background=dark

" LearnVimTheHardWay:
autocmd  VimEnter * echom ">^.^<"
