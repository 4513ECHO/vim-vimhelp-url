if exists('g:loaded_vimhelp_url') || &cp
  finish
endif
let g:loaded_vimhelp_url = v:true

let s:save_cpo = &cpo
set cpo&vim

let g:vimhelp_url_japanese = get(g:, 'vimhelp_url_japanese', &helplang =~# 'ja')

command! -bang -bar -nargs=? -complete=help HelpUrl
      \ echomsg vimhelp_url#create(<q-args>, {'yank': <bang>0})

nnoremap <Plug>(vimhelp_url) <Cmd>echo vimhelp_url#create(expand('<cword>'), {})<CR>
xnoremap <Plug>(vimhelp_url) <Cmd>echo vimhelp_url#create(<SID>get_selected(), {})<CR>
nnoremap <Plug>(vimhelp_url-yank) <Cmd>echo vimhelp_url#create(expand('<cword>'), {'yank': v:true})<CR>
xnoremap <Plug>(vimhelp_url-yank) <Cmd>echo vimhelp_url#create(<SID>get_selected(), {'yank': v:true})<CR>

function! s:get_selected() abort
  let [col1, col2] = [col('.') - 1 , col('v') - 1]
  return col1 >= col2
        \ ? getline('.')[col2:col1]
        \ : getline('.')[col1:col2]
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
