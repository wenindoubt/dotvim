"==========[ Pathogen support ]==========
call pathogen#infect()
call pathogen#helptags()

"==========[ Useful commands]==========
" :retab - replace all tabs with spaces
" gg=G   - reindent the entire file or selection with visual mode

"==========[ Who uses arrow keys? ]==========
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

"==========[ Remapping/Shortcuts ]==========
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>
vmap aa VGo1G

"==========[ My colors ]==========
colorscheme wombat
let g:airline_theme='wombat'
syntax enable

"==========[ File manipulation]==========
set tabstop=2      " Two spaces per tab
set shiftwidth=2   " Indent/outdent by two spaces
set expandtab      " Convert tabs to spaces
set shiftround     " Indent/outdent to nearest tabstop
set smarttab       " Use shiftwidths at left margin, tabstops everywhere else

set visualbell     " No beeping when erroring out
set relativenumber " Relative line numbering
set number         " Show line numbers
set scrolloff=10   " Always keep ten lines visible

set incsearch      " Search as characters are entered
set hlsearch       " Highlight matches
set smartcase      " Enable smart-case search
set ignorecase     " Always case-insensitive

set showcmd        " Show command in bottom bar
set wildmenu       " Visual autocomplete for command menu
set showmatch      " Highlight matching [{()}]

set hidden         " Hides buffer instead of closing them

set autoindent     " Retain indentation on next line
set smartindent    " Turn on autoindenting of blocks

set wrapmargin=10  " Wrap 10 characters from the edge of the window

filetype plugin indent on
"==========[ Display lines past column 80 ]==========
highlight ColorColumn ctermfg=208 ctermbg=Black

function! MarkMargin (on)
  if exists('b:MarkMargin')
    try
      call matchdelete(b:MarkMargin)
    catch /./
    endtry
    unlet b:MarkMargin
  endif
  if a:on
    let b:MarkMargin = matchadd('ColorColumn', '\%81v\s*\S', 100)
  endif
endfunction

augroup MarkMargin
  autocmd!
  autocmd  BufEnter  *       :call MarkMargin(1)
  autocmd  BufEnter  *.vp*   :call MarkMargin(0)
augroup END

"==========[ Comments are important ]==========
highlight Comment term=bold ctermfg=white

"==========[ Tabs ]==========
"nnoremap <silent> >> :call ShiftLine()<CR>|
"
"function! ShiftLine()
"  set nosmartindent
"  normal! >>
"  set smartindent
"endfunction

"==========[ Syntastic ]==========
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"==========[ VMath ]==========
vmap <expr>  ++  VMATH_YankAndAnalyse()
nmap         ++  vip++

"==========[ Toggle visibility of naughty characters ]==========
match ErrorMsg '\s\+$'

"==========[ Display Ansible documentation on highlight ]==========
let g:ansible_options = {'documentation_mapping': '<C-K>'}

"==========[ EasyMotion ]==========
" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

function! s:incsearch_config(...) abort
  return incsearch#util#deepextend(deepcopy({
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {
  \     "\<CR>": '<Over>(easymotion)'
  \   },
  \   'is_expr': 0
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> /  incsearch#go(<SID>incsearch_config())
noremap <silent><expr> ?  incsearch#go(<SID>incsearch_config({'command': '?'}))
noremap <silent><expr> g/ incsearch#go(<SID>incsearch_config({'is_stay': 1}))

function! s:config_fuzzyall(...) abort
  return extend(copy({
  \   'converters': [
  \     incsearch#config#fuzzy#converter(),
  \     incsearch#config#fuzzyspell#converter()
  \   ],
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> z/ incsearch#go(<SID>config_fuzzyall())
noremap <silent><expr> z? incsearch#go(<SID>config_fuzzyall({'command': '?'}))
noremap <silent><expr> zg? incsearch#go(<SID>config_fuzzyall({'is_stay': 1}))
