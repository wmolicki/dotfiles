set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set ttyfast

set backspace=indent,eol,start

set exrc
set relativenumber
set nu
set nohlsearch
set hidden
set noerrorbells

set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set noshowmode

set colorcolumn=80

set cmdheight=2

set updatetime=50
set autochdir

call plug#begin('~/.vim/plugged')
" treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'romgrk/nvim-treesitter-context'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
" Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
Plug 'onsails/lspkind-nvim'
Plug 'nvim-lua/lsp_extensions.nvim'

" change surrounding \" to ': cs"'
Plug 'tpope/vim-surround'
" comment files -> gc to comment in visual
Plug 'tpope/vim-commentary'

" adds 'edited' mark for commited files
Plug 'airblade/vim-gitgutter'
" git integration
Plug 'tpope/vim-fugitive'

" NERDTree
Plug 'preservim/nerdtree'
" Plug 'jistr/vim-nerdtree-tabs'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" telescope stuff
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" themes
Plug 'gruvbox-community/gruvbox'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'kyazdani42/nvim-web-devicons'
    
" status line
Plug 'nvim-lualine/lualine.nvim'

" go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" python
Plug 'davidhalter/jedi-vim'
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}
" svelte
Plug 'leafOfTree/vim-svelte-plugin'

" misc
Plug 'Raimondi/delimitMate'
Plug 'Yggdroot/indentLine'
Plug 'dracula/vim', { 'as': 'dracula' }
call plug#end()

let g:dracula_italic = 0
colorscheme dracula
" colorscheme gruvbox
highlight Normal guibg=none

let mapleader = " "
nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <silent> <C-p> :FZF<CR>

lua <<END
require('lualine').setup()

-- LSP CONFIG
require("lspconfig").gopls.setup{
  cmd = { "gopls", "serve" },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
}

local cmp = require("cmp")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

cmp.setup({
  snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
	["<C-u>"] = cmp.mapping.scroll_docs(-4),
	["<C-d>"] = cmp.mapping.scroll_docs(4),
	["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = {
      { name = 'nvim_lsp' },
      { name = "luasnip" },
      { name = "buffer" },
  },
})
-- treesitter
require'nvim-treesitter.configs'.setup{
  ensure_installed = { "go", "python" },
  sync_install = false,
  highlight = {
    enable = true,
  },
}
END

filetype plugin indent on

set autowrite
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1

let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"

" let g:fzf_layout = { 'down': '40%' }

let g:go_auto_type_info = 1


let g:NetrwIsOpen=0

function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i 
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Lexplore
    endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)

au filetype go inoremap <buffer> . .<C-x><C-o>
au filetype go nmap <Leader>ds <Plug>(go-def-split)
au filetype go nmap <Leader>dv <Plug>(go-def-vertical)

" let g:go_doc_popup_window=0
let g:go_doc_keywordprg_enabled = 0
let g:auto_save = 1

nnoremap <silent> <expr> <C-p> g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"

" close vim when nerdtree is last window
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

"" NERDTree configuration
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['node_modules','\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 50
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite,*node_modules/
nnoremap <silent> <F2> :NERDTreeFind<CR>
nnoremap <silent> <F3> :NERDTreeToggle<CR>

nnoremap <leader>n :lua vim.lsp.diagnostic.goto_next()<cr>
nnoremap <leader>p :lua vim.lsp.diagnostic.goto_prev()<cr>
nnoremap <leader>g :lua vim.lsp.buf.definition()<CR>
nnoremap K :lua vim.lsp.buf.hover()<CR>
