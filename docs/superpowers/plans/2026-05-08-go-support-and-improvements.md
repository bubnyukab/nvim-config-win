# Go Support & Config Improvements Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add batteries-included Go development support via ray-x/go.nvim and apply five quality-of-life improvements to the existing Neovim config.

**Architecture:** Each change is isolated to its own plugin file or vim-options.lua. lazy.nvim auto-discovers all files in `lua/plugins/` so new files are picked up automatically. Verification for each task is done by launching nvim and checking for errors/behavior.

**Tech Stack:** Neovim + lazy.nvim, Lua, ray-x/go.nvim, nvim-cmp, mason.nvim

---

## File Map

| File | Action | Responsibility |
|---|---|---|
| `lua/plugins/go.lua` | Create | gopls + go.nvim, auto-imports on save, Go keymaps |
| `lua/plugins/autopairs.lua` | Create | Auto-close brackets/quotes, nvim-cmp integration |
| `lua/plugins/which-key.lua` | Create | Keymap discovery popup |
| `lua/plugins/lualine.lua` | Create | Status line with gruvbox theme |
| `lua/plugins/gitsigns.lua` | Delete | Duplicate of git-stuff.lua — dead weight |
| `lua/plugins/git-stuff.lua` | Modify | Remap blame toggle from `<leader>gt` → `<leader>gb` |
| `lua/vim-options.lua` | Modify | Add relativenumber, remove overridden window nav keymaps |

---

### Task 1: Fix vim-options.lua

**Files:**
- Modify: `lua/vim-options.lua`

- [ ] **Step 1: Remove stale window nav keymaps and add relative numbers**

Open `lua/vim-options.lua`. Replace the entire file with:

```lua
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.g.mapleader = " "
vim.g.background = "dark"

vim.opt.swapfile = false

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.wo.number = true
vim.wo.relativenumber = true
```

The four `<C-h/j/k/l>` `:wincmd` keymaps are removed — they are overridden by `nvim-tmux-navigation` in `lua/plugins/nvim-tmux-navigation.lua` and serve no purpose.

- [ ] **Step 2: Verify in nvim**

Launch nvim: `nvim`

Expected:
- Line numbers show absolute on current line, relative offsets on other lines
- `:checkhealth` shows no new errors
- `<C-h/j/k/l>` still works for pane navigation (handled by nvim-tmux-navigation)

- [ ] **Step 3: Commit**

```bash
git add lua/vim-options.lua
git commit -m "config: add relative line numbers, remove stale window nav keymaps"
```

---

### Task 2: Fix git plugin duplication

**Files:**
- Delete: `lua/plugins/gitsigns.lua`
- Modify: `lua/plugins/git-stuff.lua`

- [ ] **Step 1: Delete the duplicate file**

```bash
rm lua/plugins/gitsigns.lua
```

`gitsigns.lua` defines `vim-fugitive` + `gitsigns` with no keymaps. `git-stuff.lua` defines the same plugins with the working keymaps. lazy.nvim deduplicates by plugin name so `gitsigns.lua` was redundant.

- [ ] **Step 2: Remap blame toggle in git-stuff.lua**

`<leader>gt` is being reserved for `:GoTest`. Change it to `<leader>gb` in `lua/plugins/git-stuff.lua`:

```lua
return {
  {
    "tpope/vim-fugitive",
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()

      vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {})
      vim.keymap.set("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", {})
    end,
  },
}
```

- [ ] **Step 3: Verify in nvim**

Launch nvim in a git repo. Expected:
- No errors on startup
- `<leader>gp` previews hunk
- `<leader>gb` toggles inline git blame
- `:Git` (fugitive) works

- [ ] **Step 4: Commit**

```bash
git add lua/plugins/git-stuff.lua
git rm lua/plugins/gitsigns.lua
git commit -m "fix: remove duplicate gitsigns.lua, remap blame toggle to <leader>gb"
```

---

### Task 3: Add nvim-autopairs

**Files:**
- Create: `lua/plugins/autopairs.lua`

- [ ] **Step 1: Create the plugin file**

Create `lua/plugins/autopairs.lua`:

```lua
return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
}
```

The `cmp.event:on` integration prevents double-insertion of closing characters when you confirm a completion that already includes them (e.g., a function call snippet).

- [ ] **Step 2: Verify in nvim**

Launch nvim and open any file. Enter insert mode. Expected:
- Typing `(` inserts `()` with cursor between them
- Typing `"` inserts `""` with cursor between them
- Typing `{` inserts `{}` with cursor between them
- Pressing `<BS>` after an empty pair `()` removes both characters
- Completing a snippet via nvim-cmp does not double-insert closing parens

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/autopairs.lua
git commit -m "feat: add nvim-autopairs with nvim-cmp integration"
```

---

### Task 4: Add which-key

**Files:**
- Create: `lua/plugins/which-key.lua`

- [ ] **Step 1: Create the plugin file**

Create `lua/plugins/which-key.lua`:

```lua
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },
}
```

`VeryLazy` defers load until after startup so it doesn't slow down nvim's initial render.

- [ ] **Step 2: Verify in nvim**

Launch nvim. In normal mode, press `<leader>` and wait ~1 second. Expected:
- A popup appears listing all `<leader>` keymaps (gd, gr, ca, gf, gp, gb, fg, etc.)
- Press `g` — popup updates to show `<leader>g*` bindings
- Press `<Esc>` to dismiss

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/which-key.lua
git commit -m "feat: add which-key for keymap discovery"
```

---

### Task 5: Add lualine

**Files:**
- Create: `lua/plugins/lualine.lua`

- [ ] **Step 1: Create the plugin file**

Create `lua/plugins/lualine.lua`:

```lua
return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "gruvbox",
        },
      })
    end,
  },
}
```

Uses the gruvbox theme to match your colorscheme. `nvim-web-devicons` is already used by neo-tree so it's a shared dependency with no extra install cost.

- [ ] **Step 2: Verify in nvim**

Launch nvim. Expected:
- Status line appears at the bottom of every window
- Shows: current mode (NORMAL/INSERT/etc.), filename, git branch, LSP diagnostics, filetype, line:column
- Colors match gruvbox palette

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/lualine.lua
git commit -m "feat: add lualine status line with gruvbox theme"
```

---

### Task 6: Add go.nvim

**Files:**
- Create: `lua/plugins/go.lua`

- [ ] **Step 1: Create the plugin file**

Create `lua/plugins/go.lua`:

```lua
return {
  {
    "ray-x/guihua.lua",
    build = "cd lua/fzy && make",
  },
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        lsp_cfg = {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        },
        lsp_on_attach = function(client, bufnr)
          local opts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        end,
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
```

`lsp_cfg` as a table passes your existing `cmp_nvim_lsp` capabilities to gopls so autocompletion works through the nvim-cmp pipeline you already have in `completions.lua`. `lsp_on_attach` reuses the same keymaps as your other LSP servers (`K`, `<leader>gd`, `<leader>gr`, `<leader>ca`) for consistency.

- [ ] **Step 2: Install plugins**

Launch nvim. lazy.nvim will detect the new plugins and prompt to install. Run:

```
:Lazy sync
```

Expected: `go.nvim`, `guihua.lua` install. The build step runs `go.install.update_all_sync()` which installs gopls, goimports, and other Go tooling via mason.

- [ ] **Step 3: Verify LSP and completion**

Open or create a `.go` file:

```bash
nvim /tmp/hello.go
```

Type the following content:

```go
package main

import "fmt"

func main() {
    fmt.
}
```

Expected:
- After typing `fmt.` a completion popup appears with `Println`, `Printf`, etc.
- `K` on `Println` shows hover docs
- `<leader>gd` on `Println` jumps to definition

- [ ] **Step 4: Verify auto-imports on save**

In the same file, delete the `import "fmt"` line, then save (`:w`). Expected:
- The import is automatically re-added on save
- No manual `:GoImport` needed

- [ ] **Step 5: Verify Go keymaps**

In a Go project with tests, open any `*_test.go` file. Expected:
- `<leader>gtf` with cursor on a test function runs that specific test
- `<leader>gt` runs all tests in the package
- `<leader>gfs` on a struct variable fills it with zero-value fields

- [ ] **Step 6: Commit**

```bash
git add lua/plugins/go.lua
git commit -m "feat: add go.nvim with gopls, auto-imports on save, and Go keymaps"
```
