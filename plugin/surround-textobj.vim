" surround-textobj.vim - text object motion for text surrounded by a symbol
" Copyright (C) 2013 Che-Huai Lin <lzh9102@gmail.com>

" Get the range of textobject (including the surrounding symbols).
" Returns a list with two elements: [leftcol, rightcol] or an empty list if the
" range could not be determined.
function! s:FindSurroundSymbolRange(symbol, string, position)
  let length = strlen(a:string)

  " sanity check
  if length == 0 || a:position < 0 || a:position >= length
    return []
  endif

  " find the left end
  let left = a:position
  while left >= 0
    if strpart(a:string, left, 1) == a:symbol
      break
    endif
    let left = left - 1
  endwhile

  " find the right end
  let right = a:position+1
  while right < length
    if strpart(a:string, right, 1) == a:symbol
      break
    endif
    let right = right + 1
  endwhile

  " handle the case that cursor is positioned on the right-end, for example:
  " ...$hello$...
  "          ^ <- cursor position (assume symbol is '$')
  if left == a:position && right >= length
    return <SID>FindSurroundSymbolRange(a:symbol, a:string, left-1)
  endif

  " error checking
  if left < 0 || right >= length
    " cursor is not surrounded by the symbol
    return []
  endif

  " column numbers starts from 1, so 1 should be added to the indices
  return [left+1, right+1]
endfunction

function! s:MotionSurroundSymbol(symbol, inner)
  let line = getline('.')
  let curpos = getpos('.')[2]-1

  let range = <SID>FindSurroundSymbolRange(a:symbol, line, curpos)
  if len(range) == 0
    return
  endif

  let leftcol = range[0]
  let rightcol = range[1]

  if a:inner
    " exclude surrounding symbols
    let leftcol = leftcol + 1
    let rightcol = rightcol - 1
  end

  " visual select the (left,right) range
  " if row number is zero, the cursor will stay at the current row
  call cursor(0, leftcol)
  exe 'normal v'
  call cursor(0, rightcol)
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

if !exists("g:surround_textobj_symbols")
  let g:surround_textobj_symbols = '!@#$%^&*_-+=;:/?.,'
endif

call <SID>RegisterSymbols(g:surround_textobj_symbols)
