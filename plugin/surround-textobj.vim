" surround-textobj.vim - Text-Object like motion for text surrounded by a symbol
" Copyright (C) 2013 Che-Huai Lin <lzh9102@gmail.com>

function! s:MotionSurroundSymbol(symbol, inner)
  if a:inner
    exe 'normal T' . a:symbol
    exe 'normal v'
    exe 'normal t' . a:symbol
  else
    exe 'normal F' . a:symbol
    exe 'normal v'
    exe 'normal f' . a:symbol
  end
endfunction

function! s:RegisterSymbol(symbol)
  exe 'vnoremap <silent> i' . a:symbol . ' <ESC>:call <SID>MotionSurroundSymbol(''' . a:symbol . ''', 1)<CR>'
  exe 'vnoremap <silent> a' . a:symbol . ' <ESC>:call <SID>MotionSurroundSymbol(''' . a:symbol . ''', 0)<CR>'
  exe 'onoremap <silent> i' . a:symbol . ' :call <SID>MotionSurroundSymbol(''' . a:symbol . ''', 1)<CR>'
  exe 'onoremap <silent> a' . a:symbol . ' :call <SID>MotionSurroundSymbol(''' . a:symbol . ''', 0)<CR>'
endfunction

function! s:RegisterSymbols(symbolstr)
  let length = strlen(a:symbolstr)
  let i = 0
  while i < length
    let char = strpart(a:symbolstr, i, 1)
    call <SID>RegisterSymbol(char)
    let i += 1
  endwhile
endfunction

call <SID>RegisterSymbols('!@#$%^&*_-+=;:/?.,')
