-- This is mainly used for highlighting code and some indentation
-- some languages pre installed but more can be installed later 
return{
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = { "java", "lua", "cpp", "python", "html", "css", "go" }, -- Add languages you need
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false, -- avoids double-highlighting
      },
      indent = { enable = false}, -- Enable smart indentation
    })
  end,
}
