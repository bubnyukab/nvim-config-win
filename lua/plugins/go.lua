return {
  {
    "ray-x/guihua.lua",
    build = function()
      if vim.fn.has("win32") == 0 then
        vim.fn.system("cd lua/fzy && make")
      end
    end,
  },
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("go").setup({
        lsp_cfg = {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        },
        lsp_codelens = false,
      })

      local format_sync_grp = vim.api.nvim_create_augroup("GoImport", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require("go.format").goimports()
        end,
        group = format_sync_grp,
      })

      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<leader>gt", ":GoTest<CR>", opts)
      vim.keymap.set("n", "<leader>gtf", ":GoTestFunc<CR>", opts)
      vim.keymap.set("n", "<leader>gta", ":GoAddTest<CR>", opts)
      vim.keymap.set("n", "<leader>gi", ":GoImport<CR>", opts)
      vim.keymap.set("n", "<leader>gfs", ":GoFillStruct<CR>", opts)
      vim.keymap.set("n", "<leader>gii", ":GoImpl<CR>", opts)
    end,
    event = "CmdlineEnter",
    ft = { "go", "gomod", "gosum" },
    build = ':lua require("go.install").update_all_sync()',
  },
}
