" File:        dashboard.vim
" Description: Dashboard Setup
" Author:      Satyam Goel <satyamgoel42@gmail.com>
" Version:     1.0.0
"
autocmd VimEnter * if argc() == 0 | call dashboard#DashBoard() | endif
