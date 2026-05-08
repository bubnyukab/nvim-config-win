return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      end

      if vim.fn.has("nvim-0.11") == 1 then
        vim.lsp.config('*', {
          capabilities = capabilities,
          on_attach = on_attach,
        })
        vim.lsp.enable({ 'ts_ls', 'solargraph', 'html', 'lua_ls' })
      else
        local lspconfig = require("lspconfig")
        local servers = { 'ts_ls', 'solargraph', 'html', 'lua_ls' }
        for _, server in ipairs(servers) do
          lspconfig[server].setup({
            capabilities = capabilities,
            on_attach = on_attach,
          })
        end
      end
    end,
  },
}
