set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set ttyfast

set backspace=indent,eol,start
set background=dark

set exrc
set relativenumber
set nu
set nohlsearch
set hidden
set noerrorbells

set autoread

set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
filetype plugin indent on

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
set noautochdir

call plug#begin('~/.vim/plugged')
Plug 'mbbill/undotree'
Plug 'simrat39/symbols-outline.nvim'

" test runner
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'nvim-neotest/neotest'
Plug 'nvim-neotest/neotest-plenary'
Plug 'nvim-neotest/neotest-go'
Plug 'nvim-neotest/neotest-python'

" dap (debugger)
Plug 'mfussenegger/nvim-dap'
Plug 'leoluz/nvim-dap-go'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'nvim-telescope/telescope-dap.nvim'

" treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'romgrk/nvim-treesitter-context'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
" Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
" Plug 'onsails/lspkind-nvim'
" Plug 'nvim-lua/lsp_extensions.nvim'

" support for repeating plugins with .
Plug 'tpope/vim-repeat'
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
Plug 'junegunn/fzf.vim'

" telescope stuff
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" themes
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'kyazdani42/nvim-web-devicons'
    
" status line
Plug 'nvim-lualine/lualine.nvim'

" go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" python
" Plug 'davidhalter/jedi-vim'
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}
" svelte
Plug 'leafOfTree/vim-svelte-plugin'

" prettier autoformat
Plug 'sbdchd/neoformat'

" misc
Plug 'Raimondi/delimitMate'
Plug 'Yggdroot/indentLine'
call plug#end()

lua <<END
vim.cmd[[colorscheme tokyonight]]
END

highlight Normal guibg=none

let mapleader = " "
nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <silent> <C-p> :FZF<CR>

lua <<END
require('telescope').load_extension('fzf')

require('lualine').setup()

-- autocomplete
vim.opt.completeopt = {"menu", "menuone", "noselect"}

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
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
	["<C-v>"] = cmp.mapping.scroll_docs(-4),
	["<C-b>"] = cmp.mapping.scroll_docs(4),
	["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = {
      { name = "nvim_lsp" },
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

" without this vim conceals quotes
let g:vim_json_conceal=0

" wtf is that
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
" wtf end

" autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
" autocmd FileType go nmap <leader>r  <Plug>(go-run)
" autocmd FileType go nmap <leader>t  <Plug>(go-test)

" augroup prettier_mapping
"     autocmd!
"     autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx Neoformat 
" augroup end

" this will create intermediate dir on save (no more annoying errors)
augroup Mkdir
  autocmd!
  autocmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")
augroup END

" au filetype go inoremap <buffer> . .<C-x><C-o>
" au filetype go nmap <Leader>ds <Plug>(go-def-split)
" au filetype go nmap <Leader>dv <Plug>(go-def-vertical)

" let g:go_doc_popup_window=0
let g:go_doc_keywordprg_enabled = 0
let g:go_def_mapping_enabled = 0
let g:auto_save = 1

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
nnoremap <silent> <F10> :NERDTreeFind<CR>
nnoremap <silent> <F11> :NERDTreeToggle<CR>

nnoremap <leader>n :lua vim.lsp.diagnostic.goto_next()<cr>
" TODO: nnoremap <leader>p :lua vim.lsp.diagnostic.goto_prev()<cr>
nnoremap <leader>gi :GoImports<CR>

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

lua <<END
require("neotest").setup({
    adapters = {
        require("neotest-plenary"),
        require("neotest-python")({
            dap = { justMyCode = false },
            runner = "pytest",
        }),
        require("neotest-go")({
            experimental = {
                test_table = true,
            }
        }),
    }
})

local on_attach = function(client, buffnum)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=0})
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
    vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, {buffer=0})
    vim.keymap.set("n", "gf ", vim.lsp.buf.implementation, {buffer=0})
    vim.keymap.set("n", "<leader>n", vim.diagnostic.goto_next, {buffer=0})
    vim.keymap.set("n", "<leader>p", vim.diagnostic.goto_prev, {buffer=0})
    vim.keymap.set("n", "<leader>l", "<cmd>Telescope diagnostics<cr>", {buffer=0})
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {buffer=0})
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {buffer=0})
    vim.keymap.set("n", "gr", vim.lsp.buf.references, {buffer=0})
end

-- LSP CONFIG
-- need to setup on_attach for every lsp config
require'lspconfig'.tsserver.setup{
    on_attach = on_attach
}

require'lspconfig'.pyright.setup{
    on_attach = on_attach
}

require'lspconfig'.gopls.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = { 'gopls', 'serve' },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},

}

require('dap-go').setup()
require('dapui').setup({
    layouts = {
        {
            elements = {
                { id = "scopes", size = 0.25 }, 
                "breakpoints", 
                "stacks",
                "watches",
            },
            size = 40,
            position = "left",
        },
        {
            elements = {
                "repl",
            },
            size = 0.25,
            position = "bottom",
        },
    },
})
require('nvim-dap-virtual-text').setup()

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

vim.keymap.set("n", "<F5>", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<F2>", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<F1>", ":lua require'dap'.step_into()<CR>")
vim.keymap.set("n", "<F3>", ":lua require'dap'.step_out()<CR>")
vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set("n", "<leader>dl", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
vim.keymap.set("n", "<leader>dt", ":lua require'dap-go'.debug_test()<CR>")

vim.keymap.set("n", "<leader>gs", ":SymbolsOutline<CR>")

vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")

END

" primeagen's bestest remaps
nnoremap Y yg$
xnoremap <leader>p "_dP

nnoremap <leader>y "+y
vnoremap <leader>y "+y
nmap <leader>Y "+Y

nnoremap <leader>d "_d
vnoremap <leader>d "_d

" I dont think I need this atm
inoremap <C-c> <esc>
"end

" this arcane magic will reopen file with cursor in last position
augroup vimrc-remember-cursor-position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END
