--[[
This is the public and my own preferd neovim config this can be changed real easy
--]]--

vim.opt.relativenumber = true -- Show relative line numbers for other lines
vim.opt.cursorline = true -- Hilights the cursor line

-- The following key maps are for fast one file compiles for Golang, Java and C++ 
-- Not ment to compile an entire project using <leader>t for a vert terminal
-- would be best for compiles if you dont wanna leave neovim 
-- Or just Use Tmux

-- For Java
vim.api.nvim_set_keymap(
  "n",
  "make",
  ":botright split | term javac % && java %:r<CR>",
  { noremap = true, silent = true }
)

-- For golang
vim.api.nvim_set_keymap(
  "n",
  "go",
  [[:botright split | term go run %<CR>]],
  { noremap = true, silent = true }
)

-- For c++
vim.api.nvim_set_keymap(
  "n",
  "cm",
  ":botright split | term g++ % && ./a.out <CR>",
  { noremap = true, silent = true }
)

-- Automatically switch to insert mode when opening a terminal for code compilation
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*", -- Match any terminal
  callback = function()
    vim.cmd("startinsert") -- Switch to insert mode
  end,
})

vim.cmd("set number")
vim.cmd("set laststatus=2")
vim.cmd("command! Save w")
vim.cmd("command! Nom %s/\r//g")
vim.cmd("command! Noh nohlsearch")

vim.cmd("set encoding=utf-8")
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
vim.opt.guicursor = "a:block"

--Bootstrap lazy.nvim this is really messy but this is the lazyvim plugin
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " " -- leader key is space
vim.g.maplocalleader = "\\"

vim.diagnostic.config({ -- config for the lsp diagnostic
  virtual_text = true, -- inline error/warning text
  signs = false,        -- signs in the gutter
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})


-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here

  { -- not in a file due to still being on the fence of its use 
    'MeanderingProgrammer/render-markdown.nvim',
    lazy = true,
    opts = {},
    keys = {
      {
        "<leader>0",
      }
    }
  },

    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { 'mbbill/undotree' },
    {import = "plugins.lspconfig"},
    {import = "plugins.catColor"},
    {import = "plugins.lualine"}, --5
    {import = "plugins.neotree"}, --6
    {import = "plugins.blink"}, --6
    {import = "plugins.snacks"}, --6
    {import = "plugins.treesitter"}, --12
    { 'echasnovski/mini.nvim', version = '*' },
    --end of lazy plugins here 
  },

  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = false},
})
require('mini.surround').setup()  -- better surround handling
require('mini.pairs').setup()     -- auto-pairing brackets
require('mini.diff').setup()     -- Git diff for the num line on the left
require('mini.ai').setup()     -- more text pairs not articifual inteligance

-- Remapping for better movment 
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true }) 
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

-- Leader key Remapping for other plugins
vim.api.nvim_set_keymap("n", "<leader>l", "$", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>h", "^", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>w", ":w<CR>") -- save
vim.keymap.set("n", "<leader>t", ":vertical belowright terminal<CR>") -- for quik terminal
vim.keymap.set("n", "<leader>f", ":lua Snacks.picker.files()<CR>") -- file picker
vim.keymap.set("n", "<leader>p", ":lua Snacks.picker.buffers()<CR>") -- picker for open buffers
vim.keymap.set("n", "<leader>m", ":w | bd<CR>") -- closing buffer
vim.keymap.set('n', '<leader><leader>', vim.cmd.UndotreeToggle) -- undotree
vim.keymap.set("n", "<leader>gg", ":lua Snacks.lazygit()<CR>") -- lazygit
vim.api.nvim_set_keymap("n", "<leader>nn", ":lcd %:p:h<CR>", { noremap = true, silent = true }) -- This sets the root dir 

vim.keymap.set( -- golang key map for errors
  "n",
  "<leader>ge",
  "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
)

-- not show the tabline when starting
vim.o.showtabline = 1

-- use custom tabline function
vim.o.tabline = "%!v:lua.MyTabLine()"

function _G.MyTabLine()
  local s = ""
  for i = 1, vim.fn.tabpagenr('$') do
    local winnr = vim.fn.tabpagewinnr(i)
    local bufnr = vim.fn.tabpagebuflist(i)[winnr]
    local name = vim.fn.bufname(bufnr)
    local label = vim.fn.fnamemodify(name, ":t") -- only filename (no path)

    if i == vim.fn.tabpagenr() then
      s = s .. "%#TabLineSel# " .. label .. " "
    else
      s = s .. "%#TabLine# " .. label .. " "
    end
  end
  return s .. "%#TabLineFill#"
end
