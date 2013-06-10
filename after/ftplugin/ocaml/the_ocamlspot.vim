if exists('b:loaded_the_ocamlspot')
  finish
endif
let b:loaded_the_ocamlspot = 1

let s:save_cpo = &cpo
set cpo&vim

if !executable('ocamlspot')
  echoerr 'OCamlSpotter is not installed!'
  finish
endif

if !exists('g:the_ocamlspot_no_default_auto_commands')
  let g:the_ocamlspot_no_default_auto_commands = 0
endif
if !exists('g:the_ocamlspot_no_default_key_mappings')
  let g:the_ocamlspot_no_default_key_mappings = 0
endif
if !exists('g:the_ocamlspot_no_balloon')
  let g:the_ocamlspot_no_balloon = 0
endif

command! -buffer -nargs=0 TheOCamlType call the_ocamlspot#main('type')
command! -buffer -nargs=0 TheOCamlDefPreview call the_ocamlspot#main('def', 'pedit')
command! -buffer -nargs=0 TheOCamlDefSplit call the_ocamlspot#main('def', 'split')
command! -buffer -nargs=0 TheOCamlDefVSplit call the_ocamlspot#main('def', 'vsplit')
command! -buffer -nargs=0 TheOCamlDefTab call the_ocamlspot#main('def', 'tabedit')
command! -buffer -nargs=0 TheOCamlDefEdit call the_ocamlspot#main('def', 'edit')

nnoremap <script> <Plug>(the-ocamlspot-type)        :<C-u>TheOCamlType<CR>
nnoremap <script> <Plug>(the-ocamlspot-def-preview) :<C-u>TheOCamlDefPreview<CR>
nnoremap <script> <Plug>(the-ocamlspot-def-split)   :<C-u>TheOCamlDefSplit<CR>
nnoremap <script> <Plug>(the-ocamlspot-def-vsplit)  :<C-u>TheOCamlDefVSplit<CR>
nnoremap <script> <Plug>(the-ocamlspot-def-tab)     :<C-u>TheOCamlDefTab<CR>
nnoremap <script> <Plug>(the-ocamlspot-def-edit)     :<C-u>TheOCamlDefEdit<CR>

function! s:define_highlights()
  highlight default link TheOCamlSpotTree PmenuSel
  highlight default link TheOCamlSpotSpot MatchParen
  highlight default link TheOCamlSpotTypeKind Title
  highlight default link TheOCamlSpotVarName Identifier
  highlight default link TheOCamlSpotType Type
endfunction
call s:define_highlights()

augroup the-ocamlspot
  autocmd! ColorScheme *
  autocmd! * <buffer>
  autocmd CursorHold <buffer> call s:the_ocaml_type_cursorhold()
  autocmd CursorMoved <buffer> call the_ocamlspot#clear_highlight()
  autocmd ColorScheme * call s:define_highlights()
augroup END

function! s:the_ocaml_type_cursorhold()
  if !g:the_ocamlspot_no_default_auto_commands
    TheOCamlType
  endif
endfunction

if !g:the_ocamlspot_no_default_key_mappings
  nmap <buffer> <Leader>ot <Plug>(the-ocamlspot-type)
  nmap <buffer> <Leader>op <Plug>(the-ocamlspot-def-preview)
endif

if has('gui_running') && has('balloon_eval')
  setlocal ballooneval balloonexpr=the_ocamlspot#balloon_spotter()
endif

let &cpo = s:save_cpo
unlet s:save_cpo
