vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.signcolumn = "yes"

-- Blinking cursor
vim.o.guicursor = "n-v-c-sm-i-ci-ve:block,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"

-- Colors in terminal
vim.opt.termguicolors = true

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Copy to system clipboard
vim.o.clipboard = "unnamedplus"

-- Neovim 0.12: native insert-mode autocompletion
vim.o.autocomplete = true

-- Neovim 0.12: global border for floating windows
vim.o.winborder = "rounded"

-- Assumes a Nerd Font is available
vim.g.have_nerd_font = true
