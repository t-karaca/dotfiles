vim.opt.title = true
vim.opt.titlelen = 0
vim.opt.titlestring = "%t (%{substitute(getcwd(),$HOME,'~','')}) - nvim"

vim.opt.scrolloff = 10

vim.opt.hlsearch = true

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.ruler = false

vim.opt.cursorline = true

vim.opt.signcolumn = "yes"

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.fillchars = { eob = " " }

vim.opt.wrap = false

vim.opt.backspace = "indent,eol,start"

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.showmode = false

vim.opt.termguicolors = true

vim.opt.swapfile = false
vim.opt.autoread = true

vim.opt.background = "dark"

vim.g.sass_recommended_style = false
