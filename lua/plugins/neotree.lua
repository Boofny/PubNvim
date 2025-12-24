-- This is a lot of confusing config but all that really matters is the side you want this file tree displayed
return{
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
        lazy = false,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
      keys = {
        {
          "<leader>e",
          function()
            -- Load and setup only when key is pressed
            require("neo-tree").setup({
                window = {
                position = "right",  
                },
            })
            require("neo-tree.command").execute({ toggle = true })
          end,
          desc = "Toggle Neo-tree",
        },
      },
    -- },

config = function()

require("neo-tree").setup({
    window = {
        position = "right", -- change to left or rigt
    },
  event_handlers = {
    {
      event = "file_opened",
      handler = function(file_path)
        local dir = vim.fn.fnamemodify(file_path, ":h")
        -- vim.cmd("lcd " .. dir) -- Update working directory
      end,
    },
  },
})

-- This create bellow is for when neovim is used in the terminal as such (nvim .)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 1 then
      local arg = vim.fn.argv()[1]
      if vim.fn.isdirectory(arg) == 1 then
        require("neo-tree").setup({ window = { position = "right" } }) -- (optional if not set up yet)
        require("neo-tree.command").execute({ dir = arg })
      end
    end
  end,
})

end,
}

