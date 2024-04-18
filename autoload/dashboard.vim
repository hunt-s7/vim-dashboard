" File:        dashboard.vim
" Description: Contains functions required by plugin/dashboard.vim
" Author:      Satyam Goel <goelsatyam42@gmail.com>
" Created:     18 April 2024
" Last Change: 18 April 2024
" Version:     1.0.0
"
" 
"autoload/dashboard.vim

let $DISPLAY = ''
let g:myquick_path = '~/.vim/plugged/vim-dashboard/quick/'
let g:script_path = '/bin/csh'
let g:script = 'csh'
let g:file_mapping = {}
let g:quick_access_types = g:myquick_path . 'quickaccesstypes.txt'

function! dashboard#DashBoard()
    " Clear the screen
    silent! execute 'normal! :silent! !clear<CR>'
        
    file DashBoard
    " Create an empty list to store the dashboard lines
    let dashboard_lines = []

    let total_width = winwidth(0)
    let mywidth = 60
    let total_padding_needed = total_width - mywidth
    let leading_spaces = repeat(' ', total_padding_needed / 2)

    let line1 = leading_spaces . ' __  ____   __  ___   _   ___ _  _ ___  ___   _   ___ ___'   . leading_spaces
    let line2 = leading_spaces . '|  \/  \ \ / / |   \ /_\ / __| || | _ )/ _ \ /_\ | _ \   \'  . leading_spaces
    let line3 = leading_spaces . '| |\/| |\ V /  | |) / _ \\__ \ __ | _ \ (_) / _ \|   / |) |' . leading_spaces
    let line4 = leading_spaces . '|_|  |_| |_|   |___/_/ \_\___/_||_|___/\___/_/ \_\_|_\___/'  . leading_spaces

    " Add dashboard lines to the list
    " BEGIN HEADER
    call add(dashboard_lines, "")
    call add(dashboard_lines, "")
    call add(dashboard_lines, line1)
    call add(dashboard_lines, line2)
    call add(dashboard_lines, line3)
    call add(dashboard_lines, line4)
    call add(dashboard_lines, "")
    call add(dashboard_lines, "")
    " End HEADER

    let key = 1
    let line_number = 9

    " Types
    if filereadable(expand(g:quick_access_types))
      let types = readfile(expand(g:quick_access_types))
      for type in types
        let parts = split(type)
        let quick_access_type = parts[0]
        let quick_access_file = g:myquick_path . parts[1]
        call add(dashboard_lines, "     >> QuickAccess " . quick_access_type)
        call add(dashboard_lines, "")
        let line_number += 2

        if filereadable(expand(quick_access_file))
          let files = readfile(expand(quick_access_file))
          for file in files
            let segments = split(file)
            let title = segments[0]
            let host  = segments[1]
            let path  = segments[2]
            "8 char space
            call add(dashboard_lines, "        [" . key . "] " . title)
            execute 'nnoremap <buffer> ' . key . ' :call dashboard#QuickAccess("' . file . '")<CR>'
            let g:file_mapping[line_number] = file
            let line_number += 1
            let key += 1
          endfor
          "5 char space'
          call add(dashboard_lines, "")
          call add(dashboard_lines, "")
          let line_number += 2
        endif
      endfor
    endif

    call append(0, dashboard_lines)

    normal! gg
    call cursor(11, 8)

    setlocal nomodified
    setlocal readonly
    setlocal nonumber
    setlocal norelativenumber
    nnoremap <buffer> <CR> :call dashboard#OpenFileDynamic()<CR>
    call dashboard#EnableDashBoardSyntax()
endfunction

function! dashboard#EnableDashBoardSyntax()
  set background=dark
  if version > 0
    hi clear
    if exists("syntax_on")
      syntax reset
    endif
  endif

  syntax match SectionHeader1 /|.*/
  syntax match SectionHeader2 /_.*/
  syntax match SectionHeader3 />>/
  syntax match QuickHeader    /QuickAccess.*/
  syntax match KeyBrace       /\[.\]/

  highlight Normal                                             gui=bold ctermfg=208 ctermbg=233  cterm=bold
  highlight SectionHeader1 guifg=#c526ff guibg=NONE guisp=NONE gui=bold ctermfg=202 ctermbg=NONE cterm=bold
  highlight SectionHeader2 guifg=#c526ff guibg=NONE guisp=NONE gui=bold ctermfg=202 ctermbg=NONE cterm=bold
  highlight SectionHeader3 guifg=#c526ff guibg=NONE guisp=NONE gui=bold ctermfg=202 ctermbg=NONE cterm=bold
  highlight KeyBrace       guifg=#c526ff guibg=NONE guisp=NONE gui=bold ctermfg=202 ctermbg=NONE cterm=bold
  highlight QuickHeader                                        gui=bold ctermfg=150 ctermbg=NONE cterm=bold
  highlight DashCursorLine guifg=NONE    guibg=NONE       gui=underline ctermfg=0   ctermbg=15   cterm=NONE

  au CursorMoved * call dashboard#HighlightDashboardCursor()
endfunction

function! dashboard#HighlightDashboardCursor()
  exec 'match none'
  exec 'match DashCursorLine /\%'.line('.').'l\zs.*/'
endfunction

function! dashboard#OpenFileDynamic()
  " Get the current line number
  let line_number = line('.')
  if has_key(g:file_mapping, line_number)
    call dashboard#QuickAccess(g:file_mapping[line_number])
  endif
endfunction
function! dashboard#QuickAccess(file)
  colorscheme cobalt
  let parts         = split(a:file)
  let l:title       = parts[0]
  let l:host        = parts[1]
  let l:domain      = substitute(system('echo ' . l:host . ' | cut -d "." -f 2-'), '\n', '', '')
  let l:path        = parts[2]
  let l:access_type = parts[3]
  let ssh_command   = ''
  " Extract domain from l:host
  if l:access_type == "f"
    let current_domain = substitute(system('hostname -d'), '\n', '', '')
    if current_domain != l:domain
      let ssh_command = 'gnome-terminal -- "' . g:script_path . '" -c ''ssh -t "' . l:host . '" "vim ' . l:path . '; exec "' . g:script .'""'''
      call system(ssh_command)
      exit
    else
      execute 'edit ' . l:path
    endif
  elseif l:access_type == "d"
    let ssh_command = 'gnome-terminal -- "' . g:script_path . '" -c ''ssh -t "' . l:host . '" "cd ' . l:path . '; exec "' . g:script .'""'''
    call system(ssh_command)
    exit
  endif
endfunction

