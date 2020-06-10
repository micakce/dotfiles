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
Plug 'tpope/vim-eunuch' " UNIX file commands sugar
" JUNEGUNN: !PUTO CRACK!
Plug 'junegunn/vim-easy-align' " VimEasyAlign
Plug 'junegunn/vim-slash' " Slash
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } "FZF
Plug 'junegunn/fzf.vim'
Plug 'jremmen/vim-ripgrep'
Plug 'neoclide/coc.nvim', {'branch': 'release'} "COC
Plug 'honza/vim-snippets' " VimSnippets
Plug 'wellle/targets.vim' " Targets
Plug 'michaeljsmith/vim-indent-object' " Indent based text object
Plug 'mattn/emmet-vim' "HTML
Plug 'vimwiki/vimwiki' "VimWiki
" JAVASCRIPT:
Plug 'pangloss/vim-javascript' " JavaScript syntax
Plug 'maxmellon/vim-jsx-pretty' " JSXSyntax
Plug 'airblade/vim-gitgutter' "GitGutter
Plug 'preservim/nerdtree' "NerdTree
" Plug 'ncm2/float-preview.nvim' "only works for nvim, dock LSP window to the top/bottom
Plug 'vim-python/python-syntax' "PythonSyntax
call plug#end()            " required
filetype plugin indent on    " required
let g:indentLine_enabled = 0

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
" let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_powerline_fonts = 1
let g:airline_theme='murmur'

" VimEasyMotion: Jump cursor wherever you want
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
" map  n <Plug>(easymotion-next)
" map  N <Plug>(easymotion-prev)
" map f <Leader><Leade" Gif config
" map F <Leader><Leader>F
" map t <Leader><Leader>t
" map T <Leader><Leader>T

" IndentLine: Indent guide lines
let g:indentLine_color_term = 8
" let g:indentLine_char = '┊'
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

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
" let g:fzf_layout = { 'window': {'width': 0.9, 'height': 0.6} }
" hide status bar
autocmd! FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" Files: Find fies in project with fzf
command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, fzf#vim#with_preview("down:50%"), <bang>0)

command! -bang -nargs=* MatchFileNameFind
  \ call fzf#vim#grep(
  \   'rg --hidden --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': ['--bind','ñ:preview-down,Ñ:preview-up']},"down:50%"), <bang>0)

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)


"Find: Find files by content
function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --hidden --line-number --no-heading --color=always %s --glob "!{node_modules}" || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec, "down:50%"), a:fullscreen)
endfunction
command! -nargs=* -bang Find call RipgrepFzf(<q-args>, <bang>0)

" Mappings:
noremap <c-p> :Files<CR>
noremap <c-f> :Find<CR>
nnoremap f :MatchFileNameFind<CR>
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
" nmap <leader>f <Plug>(coc-codeaction)
command! -nargs=0 Prettier :CocCommand prettier.formatFile
nnoremap p :Prettier<CR>

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
                        \ 'coc-json',
                        \ 'coc-tsserver',
                        \ 'coc-prettier',
                        \ 'coc-eslint',
                        \ 'coc-snippets',
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
" ### CocInstall coc-snippets ###
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)
" " Use <C-j> for select text for visual placeholder of snippet.
" vmap <C-l> <Plug>(coc-snippets-select)
" " Use <C-j> for jump to next placeholder, it's default of coc.nvim
" " let g:coc_snippet_next = '<c-j>'
" " Use <C-k> for jump to previous placeholder, it's default of coc.nvim
" " let g:coc_snippet_prev = '<c-k>'
" " Use <C-j> for both expand and jump (make expand higher priority.)
" " imap <C-j> <Plug>(coc-snippets-expand-jump)

" Targets: Augmented text object
" allow argument text object to work inside '{}' as well
autocmd User targets#mappings#user call targets#mappings#extend({
                        \ 'a': {'argument': [{'o': '[{([]', 'c': '[])}]', 's': ','}]}
                        \ })

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

" JSXSyntax:
let g:vim_jsx_pretty_highlight_close_tag=1

" NerdTree:
noremap <C-n> :NERDTreeToggle<CR>

" PythonSyntax:
let g:python_highlight_all = 1

" Explorer: File Navigation
let g:netrw_liststyle = 3
let g:netrw_banner = 0

" Window:
" copy yanked text to tmux pane
function! Send_to_tmux(count) abort " ------------------------------ {{{
    let _count = (a:count == 0) ? 3 : a:count
    let text = @z
    let text = substitute(text, '\n', '', 'g')
    execute "!" . text . " | jq > /dev/tty "
    execute "!tmux send-keys -t " . _count . " \"" . text . " | jq\""
    execute "!tmux send-keys -t " . _count . " Enter"
    " execute "!tmux send-keys -t 3 '" text " | jq' Enter"
    " execute "!tmux send-keys -t " . _count . "'" text "' Enter"
    unlet _count
    unlet text
endfunction
nnoremap <expr> <Leader>st '"zyip:call Send_to_tmux('.v:count.')<CR>'
xnoremap <expr> <Leader>st '"zy:call Send_to_tmux('.v:count.')<CR>'}}}

" send paragraph under curso to terminal https://vi.stackexchange.com/questions/14300/vim-how-to-send-entire-line-to-a-buffer-of-type-terminal
function s:exec_on_term(lnum1, lnum2)
  " get terminal buffer
  let g:terminal_buffer = get(g:, 'terminal_buffer', -1)
  " open new terminal if it doesn't exist
  if g:terminal_buffer == -1 || !bufexists(g:terminal_buffer)
    bel terminal
    let g:terminal_buffer = bufnr('')
    wincmd p
  " split a new window if terminal buffer hidden
  elseif bufwinnr(g:terminal_buffer) == -1
    exec 'sbuffer ' . g:terminal_buffer
    wincmd p
  endif
  " join lines with "\<cr>", note the extra "\<cr>" for last line
  " send joined lines to terminal.
  call term_sendkeys(g:terminal_buffer,
        \ join(getline(a:lnum1, a:lnum2), "\<cr>") . "\<cr>")
endfunction

command! -range ExecOnTerm call s:exec_on_term(<line1>, <line2>)
nnoremap <leader>r :'{,'}-1ExecOnTerm<cr>
vnoremap <leader>r :ExecOnTerm<cr>

" #TODO clean up the rest from here on

" Miscelaneos: Random shit that needs to organized better
" RegExp:
" nnoremap / /\v
" vnoremap / /\v
cnoremap %s, %smagic,
cnoremap \>s/ \>smagic/
" nnoremap :g/ :g/\v
" nnoremap :g// :g//

" InsertMappings:
inoremap <C-e> <end>
inoremap u <c-o>viwU<c-o>A
inoremap jk <esc>
inoremap ,cl console.log();<c-c>hi
" QuickFix: quickfix related config
" open quickfix item in vertical split
" always open file in new tab and go to tab if already open
set switchbuf=usetab
augroup filetype_qf
        autocmd!
        autocmd FileType qf nnoremap <buffer> <C-v> <C-w><Enter><C-w>L
        autocmd FileType qf nnoremap <buffer> <C-t> <C-w><Enter><C-w>T
augroup END
" CommandModeMappins:
cnoremap <c-a> <home>
cnoremap <c-j> <down>
cnoremap <c-k> <up>
set path+=**
set wildignore+=**/node_modules/**
noremap <silent> <Leader>tw :%s,\s*$,,g<CR>'':nohl<CR>
autocmd BufEnter *.hbs :set ft=html<CR>
com! FormatJSON %!python3 -m json.tool
nnoremap <Leader>cu :set undoreload=0<CR> :edit<CR>
nnoremap <Leader>E :Ex<CR>
runtime macros/matchit.vim
nnoremap <Leader>gib cib<c-c>"_cc<c-c>P
noremap <Leader>= mmgg=G'mz.
noremap <Leader>scl _iconsole.log(<c-c>A)<c-c>F;xA;<c-c>
noremap <Leader>tn :tabnew<CR>
noremap <Leader>ev :tabnew $MYVIMRC<CR>
noremap <Leader>evh :e $MYVIMRC<CR>
noremap <Leader>sv :source $MYVIMRC<CR>
noremap <Leader>br mm:s/\S/&\r/g<CR>:nohl<CR>dd'm
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o ""autocomment insertion
nnoremap <Leader>o Go
set showcmd

" Mouse and backspace
set mouse=a " on OSX press ALT and click
set bs=2 " make backspace behave like normal again
" noremap <silent> <C-n> :nohl<CR>

" Quicksave command
nnoremap  <Leader>u :update<CR>

" Quick quit command
nnoremap <Leader>q :quit<CR>

" Window mappins
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h
nnoremap <expr> <c-w><c-k> (v:count == 0 ? 5 : v:count) . '<c-w>+'
nnoremap <expr> <c-w><c-j> (v:count == 0 ? 5 : v:count) . '<c-w>-'
nnoremap <expr> <c-w><c-l> (v:count == 0 ? 5 : v:count) . '<c-w>>'
nnoremap <expr> <c-w><c-h> (v:count == 0 ? 5 : v:count) . '<c-w><'
nnoremap <silent> <leader>l :bnext<CR>
nnoremap <silent> <leader>h :bprevious<CR>
nnoremap <silent> gb :bnext<CR>
nnoremap <silent> gB :bprevious<CR>
nnoremap <silent> 0gb :bfirst<CR>
nnoremap <silent> 9gb :blast<CR>
nnoremap <silent> gl :b#<CR>
nnoremap <silent> <leader>9 :blast<CR>
nnoremap <silent> <leader>0 :bfirst<CR>
nnoremap <silent> <leader>bd :b#<CR>:bd#<CR>
set splitbelow
set splitright

" Terminal mappings
tnoremap <c-j> <c-w>j
tnoremap <c-k> <c-w>k
tnoremap <c-l> <c-w>l
tnoremap <c-h> <c-w>h
tnoremap <esc> <c-\><c-n>
tnoremap <c-w>q <c-\><c-n>

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
set wildmenu

" Useful settings
set history=700
set undolevels=700

" Real programmers don't use TABs but spaces
set tabstop=4
set softtabstop=4
" set shiftwidth=4
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

"""Move Lines
"vnoremap j :m'>+<CR>gv=gv
"vnoremap k :m-2<CR>gv=gv
"nnoremap j :normal! ddp==<CR>
"nnoremap k  :<c-u> execute "normal! dd" . v:count . "kP=="<CR>
nnoremap j :m .+1<CR>==
nnoremap k :m .-2<CR>==
inoremap j  <Esc>:m .+1<CR>==gi
inoremap k  <Esc>:m .-2<CR>==gi
vnoremap j :m '>+1<CR>gv=gv
vnoremap k :m '<-2<CR>gv=gv
nnoremap yp yyp

" Better copy/paste
" set clipboard=unnamedplus
nnoremap <Leader>y "+y
nnoremap <Leader>Y "+Y
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
noremap  <Leader>d "+d
noremap  <Leader>D "+D
noremap  <Leader>c "+c
noremap  <Leader>C "+C
noremap  <Leader>x "+x
vnoremap <Leader>y "+y

" Better search
function! Vimgrep()
    call inputsave()
    let search = input('Enter search: ')
    call inputrestore()
    execute "Rg " . search
endfunction
noremap <F3> :call Vimgrep()<CR>

" augroup myvimrc
"     autocmd!
"     autocmd QuickFixCmdPost [^l]* cwindow
"     autocmd QuickFixCmdPost l*    lwindow
" augroup END


augroup PYTHON
    autocmd!
    " autocmd ColorScheme * highlight fLiteral ctermfg=133
    " autocmd BufRead,BufEnter,InsertLeave *.py match fLiteral /{[^}]*}/
    autocmd FileType python set foldmethod=indent
augroup END

augroup XML
    autocmd!
    autocmd FileType xml let g:xml_syntax_folding=1
    autocmd FileType xml setlocal foldmethod=syntax
    autocmd FileType xml setlocal tabstop=2 softtabstop=2  shiftwidth=2
    autocmd FileType xml :%foldopen!
augroup END

augroup MARKDOWN
    autocmd!
    autocmd FileType markdown let g:indentLine_enabled = 0
" let g:indentLine_concealcursor = 'inc'
" let g:indentLine_conceallevel = 2
augroup END

augroup JSON
    autocmd!
    autocmd FileType json let g:indentLine_enabled = 0
    autocmd FileType json setlocal conceallevel=2
    autocmd FileType json setlocal foldmethod=syntax
    autocmd FileType json setlocal tabstop=2 softtabstop=2  shiftwidth=2
    autocmd FileType json :%foldopen!
" let g:indentLine_concealcursor = 'inc'
" let g:indentLine_conceallevel = 2
augroup END

augroup JAVASCRIPT
    autocmd!
    autocmd FileType javascript setlocal tabstop=2 softtabstop=2  shiftwidth=2
augroup END

augroup YAML
    autocmd!
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2
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
