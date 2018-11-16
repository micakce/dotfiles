" Plug 'Shougo/deoplete.nvim' "{{{
" Plug 'roxma/nvim-yarp'
" Plug 'roxma/vim-hug-neovim-rpc' " pip3 install neovim

" let g:deoplete#enable_at_startup = 1
" let g:deoplete#enable_smart_case = 1

"" disable autocomplete by default
" let b:deoplete_disable_auto_complete=1
" let g:deoplete_disable_auto_complete=1
" call deoplete#custom#buffer_option('auto_complete', v:false)

" if !exists('g:deoplete#omni#input_patterns')
"     let g:deoplete#omni#input_patterns = {}
" endif

" Disable the candidates in Comment/String syntaxes.
" call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])


" " set sources
" let g:deoplete#sources = {}
" let g:deoplete#sources.cpp = ['LanguageClient']
" let g:deoplete#sources.python = ['LanguageClient']
" let g:deoplete#sources.python3 = ['LanguageClient']
" let g:deoplete#sources.rust = ['LanguageClient']
" let g:deoplete#sources.c = ['LanguageClient']
" let g:deoplete#sources.vim = ['vim'] "}}}

Plug 'Shougo/neocomplete.vim' "{{{
" Disable AutoComplPop.
" let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" let g:neocomplete#disable_auto_complete = 1
" inoremap <expr><TAB>  pumvisible() ? "\<Down>" : neocomplete#start_manual_complete()
set completeopt=longest,menuone,preview
" function! OmniPopup(action) "{{{
"     if pumvisible()
"         if a:action == 'j'
"             return "\<C-N>"
"         elseif a:action == 'k'
"             return "\<C-P>"
"         endif
"     endif
"     return a:action
" endfunction "}}}
" inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
" inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags "}}}

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif