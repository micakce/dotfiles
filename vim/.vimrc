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
Plug 'pantharshit00/vim-prisma'
Plug 'altercation/vim-colors-solarized'
Plug 'aklt/plantuml-syntax'
Plug 'cespare/vim-toml'
Plug 'vim-ctrlspace/vim-ctrlspace' " To verify
Plug 'mhinz/vim-startify' " Startify
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'drewtempelmeyer/palenight.vim' " My favorite colorscheme, aparently
Plug 'vim-airline/vim-airline' " VimAirline
Plug 'vim-airline/vim-airline-themes'
Plug 'easymotion/vim-easymotion' " VimEasyMotion
Plug 'christoomey/vim-tmux-navigator'
Plug 'Yggdroot/indentLine' " IndentLine
Plug 'jiangmiao/auto-pairs' " Automatic brackets and quotes insert
Plug 'machakann/vim-highlightedyank'  " YankHighlight
Plug 'kdheepak/lazygit.nvim' " LazyGit
Plug 'APZelos/blamer.nvim' " GitBlamer
" TPOPE: ¡CAPO!
Plug 'tpope/vim-repeat' " Mini macros dot repeat
Plug 'tpope/vim-surround' " Object-text surround commands
Plug 'tpope/vim-dadbod' " Connect with databases
Plug 'tpope/vim-commentary' " VimCommentary
Plug 'tpope/vim-eunuch' " Eunuch
Plug 'tpope/vim-abolish' " Abolish
Plug 'tpope/vim-fugitive' " Fugitive
" JUNEGUNN: !PUTO CRACK!
Plug 'junegunn/gv.vim' "GV fugitive aid for commit browsing
Plug 'junegunn/vim-easy-align' " VimEasyAlign
Plug 'junegunn/rainbow_parentheses.vim' "RainBowParentheses
Plug 'junegunn/vim-peekaboo' "Peekaboo
" Plug 'junegunn/vim-slash' " Slash
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } "FZF
Plug 'junegunn/fzf.vim'
Plug 'jremmen/vim-ripgrep'
Plug 'junegunn/vim-emoji'
Plug 'neoclide/coc.nvim', {'branch': 'release'} "COC
Plug 'honza/vim-snippets' " VimSnippets
Plug 'wellle/targets.vim' " Targets
Plug 'michaeljsmith/vim-indent-object' " Indent based text object
Plug 'mattn/emmet-vim' "HTML
" JAVASCRIPT:
Plug 'pangloss/vim-javascript' " JavaScript syntax
Plug 'maxmellon/vim-jsx-pretty' " JSXSyntax
Plug 'airblade/vim-gitgutter' "GitGutter
Plug 'preservim/nerdtree' "NerdTree
Plug 'mcchrish/nnn.vim' "NNN
" Plug 'ncm2/float-preview.nvim' "only works for nvim, dock LSP window to the top/bottom
Plug 'vim-python/python-syntax' "PythonSyntax
Plug 'mustache/vim-mustache-handlebars' "PythonSyntax
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()            " required
filetype plugin indent on    " required
syntax on
colorscheme palenight
" let java_highlight_functions = 1
" Who is the boss key?
let mapleader = " "
" " Second to boss key?
" let mapleader = ","
" set background=light

" Startify:
let g:startify_bookmarks = [ {'vc': '~/.vimrc'}, { 'zc': '~/.zshrc' }, {'u': '~/paisanoscreando/uiwi-odoo-woocommerce'}, {'m': '~/paisanoscreando/mutual'} ]

" CtrlSpace:
let g:CtrlSpaceDefaultMappingKey = "<M-m> "

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

" testing rounded separators (extra-powerline-symbols):
let g:airline_left_sep = ""
let g:airline_right_sep = ""

" VimEasyMotion: Jump cursor wherever you want
map <leader>f <Leader><Leader>f
map <leader>F <Leader><Leader>F

" IndentLine: Indent guide lines
let g:indentLine_enabled = 1
let g:indentLine_conceallevel = 1
let g:indentLine_color_term = 240
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

" LazyGit:
map <leader>gg :LazyGit<CR>

" VimCommentary: Especific file comment syntax
autocmd Filetype matlab setlocal commentstring=%\ %s
autocmd Filetype json setlocal commentstring=//%s

" " Eunuch: UNIX file commands sugar
function! DuplicateCurrentFile(path)
  let path = "%:h/" . a:path
  execute "saveas " . path
  execute "edit " . path
endfunction

command! -bar -nargs=1 Duplicate call DuplicateCurrentFile(<q-args>)

" " Fugitive:
" set statusline+=%{FugitiveStatusline()}

" JUNEGUNN: ¡PUTO CRACK!

" Peekaboo:
let g:peekaboo_prefix="<leader>"

" VimEasyAlign: Best aligment plugin ever
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" RainBowParentheses:
let g:rainbow#max_level = 16
" let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]

" Slash: Improved search highlighting
source $HOME/dotfiles/vim/slash.vim
if has('timers')
  " Blink 2 times with 50ms interval
  noremap <expr> <plug>(slash-after) 'zz'.slash#blink(2, 60)
else
  noremap <plug>(slash-after) zz
endif

" FZF: Everything fuzzy finder
" General_options:
noremap <c-b> :Buffers<CR>
nnoremap <M-t> :Tags<CR>
nnoremap <M-T> :BTags<CR>
nnoremap <M-h> :History:<CR>
" Open in a new full window
let g:fzf_layout = { 'window': 'enew' }
" let g:fzf_layout = { 'window': {'width': 0.9, 'height': 0.6} }

" Files: Find files by name
command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview("down:50%"), <bang>0)
noremap <c-p> :Files<CR>

" FindFzf: Find files by content
command! -bang -nargs=* FindFzf
      \ call fzf#vim#grep(
      \ "rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>),
      \ 1,
      \ fzf#vim#with_preview({'options': ['--bind','ñ:preview-down,Ñ:preview-up','--delimiter', ':', '--nth', '4..' ]},"down:50%"),
      \ <bang>0)
nnoremap <c-f> :FindFzf<CR>

" FindFzfMatchFileName: Match file name as well as content
command! -bang -nargs=* FindFzfMatchFileName
      \ call fzf#vim#grep(
      \   'rg --hidden --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>),
      \   1,
      \   fzf#vim#with_preview({'options': ['--bind','ñ:preview-down,Ñ:preview-up']},"down:50%"),
      \   <bang>0)
nnoremap <M-f> :FindFzfMatchFileName<CR>

" FindRgFzf: Find files by content using regex
function! RgFzf(query, fullscreen)
  let command_fmt = 'rg --smart-case --column --hidden --line-number --no-heading --color=always %s --glob "!{node_modules}" || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec, "down:50%"), a:fullscreen)
endfunction
command! -nargs=* -bang FindRgFzf call RgFzf(<q-args>, <bang>0)
noremap <M-r> :FindRgFzf<CR>

" Templates: Insert custom template
command! -bang -nargs=* InsertTemplate
      \ call fzf#run(fzf#vim#with_preview({
      \               'dir': '~/dotfiles/vim/templates',
      \               'source': 'ls',
      \               'sink': 'read',
      \               'window': {'width': 0.85, 'height': 0.85},
      \               }, 'down:70%'))
noremap <M-i> :InsertTemplate<CR>

" Tags: Replacing ctags?
nnoremap <leader>] :call fzf#vim#tags(expand('<cword>'), {'options': '--exact --select-1 --exit-0 --no-reverse'})<CR>

" " CompleteLine:
" inoremap <expr> <c-x><c-s-l> fzf#vim#complete(fzf#wrap({
"       \ 'prefix': '^.*$',
"       \ 'source': 'rg -n ^ --color always',
"       \ 'options': '--ansi --delimiter : --nth 3..',
"       \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }}))

" " DeleteBuffers:
function! s:format_buffer(b)
  let l:name = bufname(a:b)
  let l:name = empty(l:name) ? '[No Name]' : fnamemodify(l:name, ":p:~:.")
  let l:flag = a:b == bufnr('')  ? '%' :
        \ (a:b == bufnr('#') ? '#' : ' ')
  let l:modified = getbufvar(a:b, '&modified') ? ' [+]' : ''
  let l:readonly = getbufvar(a:b, '&modifiable') ? '' : ' [RO]'
  let l:extra = join(filter([l:modified, l:readonly], '!empty(v:val)'), '')
  return substitute(printf("[%s] %s\t%s\t%s", a:b, l:flag, l:name, l:extra), '^\s*\|\s*$', '', 'g')
endfunction
function! s:delete_buffers()
  let l:preview_window = get(g:, 'fzf_preview_window', &columns >= 120 ? 'right': '')
  let l:options = [
        \   '-m',
        \   '--tiebreak=index',
        \   '-d', '\t',
        \   '--prompt', 'Delete> '
        \ ]
  if len(l:preview_window)
    let l:options = extend(l:options, get(fzf#vim#with_preview(
          \   {"placeholder": "{2}"},
          \   l:preview_window
          \ ), 'options', []))
  endif
  return fzf#run(fzf#wrap({
        \ 'source':  map(
        \   filter(
        \     range(1, bufnr('$')),
        \     {_, nr -> buflisted(nr) && !getbufvar(nr, "&modified")}
        \   ),
        \   {_, nr -> s:format_buffer(nr)}
        \ ),
        \ 'sink*': {
        \   lines -> execute('bdelete ' . join(map(lines, {
        \     _, line -> substitute(split(line)[0], '^\[\|\]$', '', 'g')
        \   })), 'silent!')
        \ },
        \ 'options': l:options,
        \}))
endfunction
command! BD call s:delete_buffers()

" Complete Path:
function! FZF_complete_path_obsidian()
  return fzf#run({
        \ 'options': '--preview "bat --color=always {}.md" --preview-window down:70%',
        \ 'source': 'fd -H --extension md --exec echo {.}',
        \ 'sink': { line -> execute('normal! i' .. line) },
        \ 'window': {'width': 0.9, 'height': 0.85},
        \ })
endfunction

function! FZF_complete_path()
  return fzf#vim#complete#path(
        \ 'fd -H',
        \ {'window':
        \   {
        \   'width': 0.8,
        \   'height': 0.8,
        \   }
        \ })
endfunction
inoremap <expr> <c-x><c-f> FZF_complete_path()


"deprecated
function! Y_cursor_offset()
  let visible_lines = line('w$') - line('w0')
  if line('w$') < winheight(0)
    return 0.3
  endif
  let current_line = line('.') - line('w0')
  let offset = current_line/(visible_lines*1.0)
  let shift_offset = offset + offset*0.2
  return shift_offset
endfunction

"deprecated
function! X_cursor_offset()
  if col('.') <= 2
    return 0.05
  endif
  let offset = (col('.')*1.0)/winwidth(0)
  let shift_offset = offset + offset*0.8 + 0.02
  return shift_offset
endfunction

" COC: LSP auto-completion engine
set hidden
set updatetime=300
set signcolumn=yes
" set completeopt+=noselect
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <M-r> coc#refresh()

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
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" nmap <leader>f <Plug>(coc-codeaction)
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)



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
      \ 'coc-yaml',
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
" " Go:
" autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')

" Targets: Augmented text object
" allow argument text object to work inside '{}' as well
autocmd User targets#mappings#user call targets#mappings#extend({
      \ 'a': {'argument': [{'o': '[{([]', 'c': '[])}]', 's': ','}]}
      \ })

" JSXSyntax:
let g:vim_jsx_pretty_highlight_close_tag=1

" " NerdTree:
noremap <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
noremap <silent> <leader>nf :NERDTreeFind<CR>

" NNN:
let g:nnn#set_default_mappings = 0
nnoremap <silent> <leader>nn :NnnPicker<CR>
" let g:nnn#layout = { 'left': '~20%' } " or right, up, down
let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }

" PythonSyntax:
let g:python_highlight_all = 1

" Explorer: File Navigation
let g:netrw_liststyle = 3
let g:netrw_banner = 0

" Window:
" copy yanked text to tmux pane
function! Send_to_tmux(count) " ------------------------------ {{{
  let _count = (a:count == 0) ? 'bottom-right' : a:count
  let text = @z
  let text = substitute(text, '\n', '\r', 'g')
  let text = substitute(text, "'", '"', 'g')
  " let text = substitute(text, '\$$', '\$$', 'g')
  " execute "!" . text . " | jq > /dev/tty "
  " execute "!tmux send-keys -t " . _count . " \"" . text . " | jq\""
  " execute "!tmux send-keys -t " . _count . " Enter"
  " execute "!tmux send-keys -t 3 '" text " | jq' Enter"
  silent execute "!tmux send-keys -Rt" . _count . " '" .  text  . "' Enter"
  " execute '!tmux send-keys -t 2 ' . '"hola mardito" Enter'
  unlet _count
  unlet text
endfunction
nnoremap <expr> <Leader>st '"zyip:call Send_to_tmux('.v:count.')<CR>'
xnoremap <expr> <Leader>st '"zy:call Send_to_tmux('.v:count.')<CR>'
"}}}

" send paragraph under curso to terminal
if has("nvim")
  au! TermClose * if (exists("g:last_terminal_chan_id") && exists("b:terminal_job_id") && g:last_terminal_chan_id == b:terminal_job_id) | unlet g:last_terminal_chan_id | endif
  " https://vi.stackexchange.com/questions/21449/send-keys-to-a-terminal-buffer
  function! Exec_on_term(cmd)
    if a:cmd=="normal"
      exec "normal mk\"vyip"
    else
      exec "normal gv\"vy"
    endif
    if !exists("g:last_terminal_chan_id")
      vs
      terminal
      let g:last_terminal_chan_id = b:terminal_job_id
      wincmd p
    endif

    if getreg('"v') =~ "^\n"
      call chansend(g:last_terminal_chan_id, expand("%:p")."\n")
    else
      call chansend(g:last_terminal_chan_id, @v)
    endif
    exec "normal `k"
  endfunction
else
  " https://vi.stackexchange.com/questions/14300/vim-how-to-send-entire-line-to-a-buffer-of-type-terminal
  function! Exec_on_term(cmd)
    " get terminal buffer
    exec "normal yip"
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
    " send joined lines to terminal.
    if (a:cmd=="normal")
      call term_sendkeys(g:terminal_buffer, @")
    else
      call term_sendkeys(g:terminal_buffer, @*)
    endif
  endfunction
endif
nnoremap <leader>r :call Exec_on_term("normal")<CR>
vnoremap <leader>r :<c-u>call Exec_on_term("visual")<CR>


" #TODO clean up the rest from here on

" Miscelaneos: Random shit that needs to organized better
inoremap  ``<left>
inoremap  ``````<left><left><left>

" RegExp:
" nnoremap / /\v
" vnoremap / /\v
" cnoremap %s, %smagic,
" cnoremap \>s/ \>smagic/
" nnoremap :g/ :g/\v
" nnoremap :g// :g//
set magic


" InsertMappings:
inoremap <C-e> <end>
inoremap u <esc>viwUea
inoremap <M-u> <esc>viwUea
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


augroup obsidian
  autocmd!
  " autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
  autocmd InsertLeave *.md write
  autocmd BufNewFile,BufRead *.md nnoremap <CR> ciW[[<c-o>p]]<c-c>
  autocmd BufNewFile,BufRead *.md nnoremap <M-CR> ciW[[<c-o>p]]<c-c>:e <c-r>".md<CR>
  autocmd BufNewFile,BufRead *.md inoremap <M-CR> [[]]<left><left><c-o>:call FZF_complete_path_obsidian()<CR>
  autocmd BufNewFile,BufRead *.md vnoremap <M-CR> s[[<c-o>p]]<c-c>:e <c-r>".md<CR>
  autocmd BufRead,BufNewFile $HOME/obsidian/* setlocal path+=$KB_DIRECTORY/**
  autocmd BufRead,BufNewFile $HOME/obsidian/* set suffixesadd+=.md
augroup END

" CommandModeMappins:
cnoremap <c-a> <home>
cnoremap <c-j> <down>
cnoremap <c-k> <up>

set path+=**
set wildignore+=**/node_modules/**
" noremap <silent> <Leader>tw :%s,\s*$,,g<CR>'':nohl<CR>
" autocmd BufEnter *.hbs :set ft=html<CR>
com! FormatJSON %!python3 -m json.tool
nnoremap <silent> <Leader>cu :set undoreload=0 <bar> edit<CR>
nnoremap <Leader>E :Ex<CR>
runtime macros/matchit.vim
nnoremap <Leader>gib cib<c-c>"_cc<c-c>P
noremap <Leader>= :call IndentBuffer()<CR>
noremap <Leader>scl _iconsole.log(<c-c>A)<c-c>F;xA;<c-c>
noremap <Leader>tn :tabnew<CR>
noremap <Leader>ev :tabnew $MYVIMRC<CR>
noremap <Leader>evh :e $MYVIMRC<CR>
noremap <Leader>sv :source $MYVIMRC<CR>
noremap <Leader>br mm:s/\S/&\r/g<CR>:nohl<CR>dd'm
noremap <Leader>bo :%bd<bar>e#<CR>
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o ""autocomment insertion
nnoremap <Leader>o Go
set showcmd

" Mouse and backspace
set mouse=a " on OSX press ALT and click
set bs=2 " make backspace behave like normal again

" Quicksave command
nnoremap  <Leader>u :update<CR>
command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!

" Quick quit command
nnoremap <Leader>q :quit<CR>

" Window mappins
nnoremap <c-j> wincmd j
nnoremap <c-k> wincmd k
nnoremap <c-l> wincmd l
nnoremap <c-h> wincmd h
" nnoremap <c-w>l <c-w>l:vertical resize 130<CR>
" nnoremap <c-w>h <c-w>h:vertical resize 130<CR>
nnoremap <expr> <c-w><c-k> '<c-c>' . (v:count == 0 ? 12 : v:count) . '<c-w>+'
nnoremap <expr> <c-w><c-j> '<c-c>' . (v:count == 0 ? 12 : v:count) . '<c-w>-'
nnoremap <expr> <c-w><c-l> '<c-c>' . (v:count == 0 ? 12 : v:count) . '<c-w>>'
nnoremap <expr> <c-w><c-h> '<c-c>' . (v:count == 0 ? 12 : v:count) . '<c-w><'
nnoremap <silent> <leader>l :bnext<CR>
nnoremap <silent> <leader>h :bprevious<CR>
nnoremap <silent> gn :bnext<CR>
nnoremap <silent> gp :bprevious<CR>
nnoremap <silent> gl :b#<CR>
nnoremap <silent> <leader>9 :blast<CR>
nnoremap <silent> <leader>0 :bfirst<CR>
nnoremap <silent> <leader>bd :blast<CR>:bd#<CR>
set splitbelow
set splitright



" Terminal mappings
tnoremap <M-j> <c-\><c-n><c-w>j
tnoremap <M-k> <c-\><c-n><c-w>k
tnoremap <M-l> <c-\><c-n><c-w>l
tnoremap <M-h> <c-\><c-n><c-w>h
tnoremap <c-j> <c-\><c-n><c-w>j
tnoremap <c-k> <c-\><c-n><c-w>k
tnoremap <c-l> <c-\><c-n><c-w>l
tnoremap <c-h> <c-\><c-n><c-w>h
tnoremap <esc> <c-\><c-n>
tnoremap <c-w>q <c-\><c-n>
if has('nvim')
  augroup nvim_term
    autocmd BufWinEnter,WinEnter term://* startinsert
    autocmd TermOpen,TermEnter term://* startinsert
  augroup END
endif

" map sort function to a key
vnoremap <Leader>s :sort<CR>

"Easy block indetentation
vnoremap < <gv
vnoremap > >gv



autocmd Syntax * syn match TrailSpace /\s\+$/
highlight TrailSpace ctermbg=darkred

augroup REST
  autocmd!
  autocmd BufRead,BufEnter *.rest,*.http,*.curl set ft=sh

  autocmd Syntax * syn match RestGet /http GET/
  autocmd Syntax * syn match RestGet /curl .*GET/
  highlight RestGet ctermfg=45 cterm=bold

  autocmd Syntax * syn match RestPost /http POST/
  autocmd Syntax * syn match RestPost /curl .*POST/
  highlight RestPost ctermfg=40 cterm=bold

  autocmd Syntax * syn match RestPut /http PUT/
  autocmd Syntax * syn match RestPut /curl .*PUT/
  highlight RestPut ctermfg=166 cterm=bold

  autocmd Syntax * syn match RestDelete /http DELETE/
  autocmd Syntax * syn match RestDelete /curl .*DELETE/
  highlight RestDelete ctermfg=196 cterm=bold
augroup end

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


" set ((cursor|color)|(line|column))
set cursorline
highlight Cursorline cterm=none ctermbg=236
set tw=89 " width of document (used by gd)
set colorcolumn=90
highlight colorcolumn ctermbg=236
" Showing line numbers and length
set number " show line numbers
set relativenumber "show relative line numbers
set nowrap " don't automatically wrap on load
" set fo-=t " don't automatically wrap text when typing
set wildmenu

" Useful settings
set history=700
set undolevels=700

" Real programmers don't use TABs but spaces
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround
set expandtab


" Disable stupid backup and swap files - they trigger too many events
" for file system watchers
set nobackup
set nowritebackup
set noswapfile

"""Move Lines
if has("nvim")
  nnoremap <M-j> :m .+1<CR>==
  nnoremap <M-k> :m .-2<CR>==
  inoremap <M-j>  <Esc>:m .+1<CR>==gi
  inoremap <M-k>  <Esc>:m .-2<CR>==gi
  vnoremap <M-j> :m '>+1<CR>gv=gv
  vnoremap <M-k> :m '<-2<CR>gv=gv
else
  nnoremap j :m .+1<CR>==
  nnoremap k :m .-2<CR>==
  inoremap j  <Esc>:m .+1<CR>==gi
  inoremap k  <Esc>:m .-2<CR>==gi
  vnoremap j :m '>+1<CR>gv=gv
  vnoremap k :m '<-2<CR>gv=gv
endif
nnoremap yp "-yy"-p
nnoremap yP "-yy"-P

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
nnoremap <Leader>cfp :let @+=expand("%:p")<CR>
nnoremap <Leader>cft :let @+=expand("%:t")<CR>
nnoremap <Leader>cfh :let @+=expand("%:h")<CR>
function! Duplicate_File()
  let name = input('Enter filename: ')
  silent execute '!cp % %:h/' . name
  silent execute 'e %:h/' . name
endfunction
noremap <leader>df :call Duplicate_File()<CR>


""" Custom Functions
"" Trim Whitespaces
function! s:TrimWhitespaces()
  let l:save = winsaveview()
  %s/\\\@<!\s\+$//e
  call winrestview(l:save)
endfunction
command! TW call s:TrimWhitespaces()

function! IndentBuffer()
  let l:save = winsaveview()
  exec "normal gg=G"
  call winrestview(l:save)
endfunction

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

if has("nvim") " ------------------------------- {{{
  function! Compile()
    if  &filetype=="html"
      silent !clear
      execute "!google-chrome " . bufname("%")
    elseif &filetype=="javascript"
      silent !clear
      execute "!nodejs " . bufname("%")
    elseif &filetype=="python"
      silent !clear
      execute "update | !python3 %"
    elseif &filetype=="lua"
      silent !clear
      execute "update | !lua %"
    elseif &filetype=="wast"
      silent !clear
      execute "update | !wat2wasm %"
    elseif &filetype=="rust"
      silent !clear
      execute "update | !rustc % && ./%:r"
    elseif &filetype=="go"
      silent !clear
      execute "update | sp | term go run %"
    endif
  endfunction
else
  function! Compile()
    if  &filetype=="html"
      silent !clear
      execute "!google-chrome " . bufname("%")
    elseif &filetype=="javascript"
      silent !clear
      execute "!nodejs " . bufname("%")
    elseif &filetype=="python"
      silent !clear
      execute "update | !python3 %"
    elseif &filetype=="go"
      silent !clear
      execute "update | !go run %"
    endif
  endfunction
endif
nnoremap <silent> ¢ :call Compile()<CR>
nnoremap <silent> € :call Compile()<CR>
"}}}

" Better search
set hlsearch
set incsearch
set ignorecase
set smartcase
" set inccommand=split

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
  " autocmd FileType xml :%foldopen!
augroup END

augroup MARKDOWN
  autocmd!
augroup END

augroup JSON
  autocmd!
  autocmd FileType json setlocal foldmethod=syntax | setlocal nofoldenable
  autocmd FileType json syntax match Comment +\/\/.\+$+
  " let g:indentLine_conceallevel = 0
  " autocmd FileType json :%foldopen!
  " let g:indentLine_concealcursor = 'inc'
augroup END

function! InsertJavaPackage()
  let dir = expand('%:h')
  if !(dir =~ "^.*\/src\/")
    return
  end
  let dir = substitute(dir, "^.*\/src\/", "", "")
  let dir = substitute(dir, "\/", ".", "g")
  let dir = "package " . dir . ";"
  let result = append(0, dir)
  let filename = expand("%:t")
  let filename = substitute(filename, "\.java", "", "")
  let result = append(2, "")
  let result = append(3, "public class " . filename . " {")
  let result = append(4, "}")
endfunction

augroup JAVA
  autocmd!
  autocmd BufNewFile *.java call InsertJavaPackage()
augroup END

augroup JAVASCRIPT
  autocmd!
  autocmd FileType javascript let g:indentLine_enabled = 1
augroup END

" augroup YAML
"   autocmd!
" augroup END

source $HOME/dotfiles/vim/LISPCloseParens.vimrc
source $HOME/dotfiles/vim/foldSetting.vimrc
