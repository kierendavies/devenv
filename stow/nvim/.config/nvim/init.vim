call plug#begin()
Plug 'airblade/vim-gitgutter'
Plug 'bfrg/vim-jq'
Plug 'frazrepo/vim-rainbow'
Plug 'GEverding/vim-hocon'
Plug 'godlygeek/tabular'
Plug 'mfussenegger/nvim-dap'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdcommenter'
Plug 'preservim/nerdtree'
Plug 'preservim/vim-markdown'
Plug 'preservim/vim-pencil'
Plug 'scalameta/coc-metals'
Plug 'tomasiser/vim-code-dark'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-jdaddy'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-syntastic/syntastic'
call plug#end()

set number

set mouse=a

let mapleader=','

nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

if $TERM == 'alacritty'
  set termguicolors
endif

" Colour scheme is not available during first run when plugins are installed.
" https://stackoverflow.com/a/5702498
try
  colorscheme codedark
catch /^Vim\%((\a\+)\)\=:E185/
endtry
let g:airline_theme = 'codedark'

let g:airline_powerline_fonts = 1

"  let g:rainbow_active = 1

" Use <tab> to both trigger and confirm completion.
" https://github.com/neoclide/coc.nvim/wiki/Completion-with-sources
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <silent><expr> <Tab>
  \ pumvisible() ? coc#_select_confirm() :
  \ <SID>check_back_space() ? "\<Tab>" :
  \ coc#refresh()

let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

let g:jq_highlight_function_calls = 1
let g:jq_highlight_objects = 1

let g:pencil#wrapModeDefault = 'soft'
let g:airline_section_x = '%{PencilMode()}'
augroup pencil
  autocmd!
  autocmd FileType markdown call pencil#init()
augroup END
