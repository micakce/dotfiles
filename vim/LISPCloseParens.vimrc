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
