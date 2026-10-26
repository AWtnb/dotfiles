" 矩形選択の端に連番を挿入する
" 使い方: :'<,'>Seq [開始値] [桁数] [l|r]
"   l: 左端に挿入 (既定)  r: 右端の直後に挿入
function! s:Seq(line1, line2, start, width, side) abort
  let l:left = min([virtcol("'<"), virtcol("'>")])
  let l:right = max([virtcol("'<"), virtcol("'>")])
  let l:n = a:start
  let l:fmt = '%0' . a:width . 'd'

  for l:lnum in range(a:line1, a:line2)
    let l:line = getline(l:lnum)
    let l:text = printf(l:fmt, l:n)

    " 左端: 左端桁の手前 / 右端: 右端桁の次の位置
    let l:vcol = a:side ==# 'r' ? l:right + 1 : l:left
    let l:idx = byteidx(l:line, l:vcol - 1)

    " 行が短くて届かない場合は、右端指定のときだけ行末に追加
    if l:idx < 0
      if a:side !=# 'r'
        continue
      endif
      let l:idx = len(l:line)
    endif

    call setline(l:lnum, strpart(l:line, 0, l:idx) . l:text . strpart(l:line, l:idx))
    let l:n += 1
  endfor
endfunction

command! -range -nargs=* Seq call s:Seq(<line1>, <line2>,
      \ get([<f-args>], 0, 1) + 0,
      \ get([<f-args>], 1, 0) + 0,
      \ get([<f-args>], 2, 'l'))