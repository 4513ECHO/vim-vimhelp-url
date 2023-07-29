let s:base_url = 'https://vim-jp.org/vimdoc-%s/%s.html#%s'

function! vimhelp_url#create(subject, options = {}) abort
  let prev_is_help = &buftype ==# 'help'
  execute 'help' a:subject
  " NOTE: index.html is invalid as vimdoc webpage
  let lang = g:vimhelp_url_japanese ? 'ja' : 'en'
  let file = expand('%:t:r:s?^index$?vimindex?')
  let subject = expand('<cword>')

  if prev_is_help
    execute "normal! \<C-t>"
  else
    helpclose
  endif
  let url = printf(s:base_url, lang, file, s:escape(subject))
  if a:options->get('yank', v:false)
    call setreg(v:register, url)
  endif
  return url
endfunction

" Escape reversed/unsafe chars in URL
function! s:escape(string) abort
  return a:string->substitute('[&$+,/:;=?@# <>[\]{}|\\^%"'']',
        \ { m -> char2nr(m[0])->printf('%%%02X') }, 'g')
endfunction
