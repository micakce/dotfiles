vim.cmd("command! LS call fzf#run(fzf#wrap({'source': 'ls'}))")
vim.cmd([=[
command! Files call fzf#run(
                         \  fzf#wrap(
                         \      {
                         \          'source': 'fd', 
                         \          'options':[
                         \             '--info=inline', '--multi',
                         \              '--preview=[ -d {} ] && tree --dirsfirst -C {} -I node_modules ||  bat --color=always {} | head -200;',
                         \              '--prompt=Files> ',
                         \              GetFzfPreviewWindow()
                         \          ]
                         \      }
                         \   )
                         \ )

command! FilesRG call fzf#run(
                         \  fzf#wrap(
                         \      {
                         \          'source': 'rg --column --line-number --no-heading --color=never --smart-case . ',
                         \          'sink': function("SplitColon"),
                         \          'options':[
                         \             '--info=inline', '--multi',
                         \              '--preview=[ -d $(echo {} | cut -f1 -d":") ] && tree --dirsfirst -C $(echo {} | cut -f1 -d":") -I node_modules ||  bat --color=always $(echo {} | cut -f1 -d":") | head -200;',
                         \              '--prompt=FilesGrep> ',
                         \              GetFzfPreviewWindow()
                         \          ]
                         \      }
                         \   )
                         \ )

command! Buff call fzf#run(
                         \  fzf#wrap(
                         \      {
                         \          'source': map(copy(getbufinfo()), 'v:val.bufnr'),
                         \          'options':[
                         \             '--info=inline', '--multi',
                         "\              '--preview=[ -d $(echo {} | cut -f1 -d":") ] && tree --dirsfirst -C $(echo {} | cut -f1 -d":") -I node_modules ||  bat --color=always $(echo {} | cut -f1 -d":") | head -200;',
                         \              '--prompt=Buffers> ',
                         "\              GetFzfPreviewWindow()
                         \          ]
                         \      }
                         \   )
                         \ )

function! SplitColon(file)
  let filename = split(a:file, ':')[0]
  execute 'edit' l:filename
endfunction

function! GetFzfPreviewWindow()
  if &columns < 160
    return '--preview-window=down:80%'
  else
    return '--preview-window=right:70%'
  endif
endfunction

noremap <M-f> :Files<CR>
noremap <M-g> :FilesRG<CR>

]=])
