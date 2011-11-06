" vimcity.vim  : something something'
" Version      : 0.1
" Maintainer   : jackie kircher <kircher.jackie@gmail.com>
" License      : WTFPL

" ** JUMP SHIP ** "
if v:version < 600 || !has("ruby")
  echomsg 'Your version of vim must be compiled with ruby support'
  finish
end

if !exists('loaded_genutils')
  runtime plugin/genutils.vim
endif
if !exists('loaded_genutils') || loaded_genutils < 200
  echomsg 'You need the latest version of genutils.vim plugin'
  finish
endif

" ** LOAD FILE? ** "
if exists("loaded_vimcity")
  finish "too many vimcity"
  " unload görillas here instead?
endif
let loaded_vimcity = 1
let s:user_cpo = &cpo " store current compatible-mode
set cpo&vim           " go into noncompatible-mode

" ## CONFIGURATION ## "
" variable script path
if !exists("vimcity_path")
  let s:vim_path = split(&runtimepath, ',')
  let s:vimcity_path = s:vim_path[0]."/plugin/vimcity.vim"
else
  let s:vimcity_path = vimcity_path
  unlet vimcity_path
end

" ## new command: VimCity ## "
command! -nargs=0 VimCity :call <SID>vimcity(<args>)

function! s:vimcity(...)
  call vimcity#vimcity()
endfunction

function! vimcity#vimcity()
  try
    call s:play()
  catch /^Vim:Interrupt$/
    " Do nothing?
  finally
    " Still nothing?
  endtry
endfunction

function! s:play()
  exec "tabnew Welcome_to_VimCity"
  "call genutils#SetupScratchBuffer()
  setlocal noreadonly
  setlocal nonumber
  setlocal noswapfile
  setlocal buftype=nofile
  setlocal nowrap

  exec "sp VimCity"
  exec "resize 200"
  setlocal noreadonly
  setlocal nonumber
  setlocal noswapfile
  setlocal buftype=nofile
  setlocal nowrap

  " would be nice if this worked...
  "call genutils#MoveCursorToNextInWinStack('D')

  " load the game!
  ruby load "lib/vimcity.rb"
  ruby VimCityGame.new
endfunction

let &cpo = s:user_cpo " restore user's compatible-mode
unlet s:user_cpo
