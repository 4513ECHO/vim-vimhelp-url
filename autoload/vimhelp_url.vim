function! vimhelp_url#create(subject, options) abort
  let url_base = g:vimhelp_url_japanese
        \ ? 'https://vim-jp.org/vimdoc-ja/%s.html#%s'
        \ : 'https://vim-jp.org/vimdoc-en/%s.html#%s'
  let prev_is_help = &buftype ==# 'help'
  execute 'help' a:subject
  " NOTE: index.html is invalid as vimdoc webpage
  let file = expand('%:t:r:s?^index$?vimindex?')
  let subject = expand('<cword>')
  if prev_is_help
    execute "normal! \<C-t>"
  else
    helpclose
  endif
  let url = printf(url_base, file, vimhelp_url#escape(subject))
  if get(a:options, 'yank', v:false)
    call setreg(v:register, url)
  endif
  return url
endfunction

function! s:urlencode_char(char) abort
  let result = ''
  for i in range(strlen(a:char))
    let result ..= printf('%%%02X', char2nr(a:char[i]))
  endfor
  return result
endfunction

" Escape reversed/unsafe chars in URL
function! vimhelp_url#escape(string)
  return substitute(a:string,
        \ '[&$+,/:;=?@# <>[\]{}|\\^%"'']',
        \ '\=s:urlencode_char(submatch(0))', 'g')
endfunction
