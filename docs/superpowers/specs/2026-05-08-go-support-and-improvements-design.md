# Neovim Go Support & Config Improvements

**Date:** 2026-05-08

## Overview

Add batteries-included Go development support using `ray-x/go.nvim` and apply several quality-of-life improvements to the existing config.

---

## 1. Go Support (`lua/plugins/go.lua` — new file)

### Plugins
- `ray-x/go.nvim` — batteries-included Go plugin
- `ray-x/guihua.lua` — required UI dependency for go.nvim

### Configuration
- Lazy-load on `ft = {"go", "gomod", "gosum"}` and `event = "CmdlineEnter"`
- `lsp_cfg` set as a table with `cmp_nvim_lsp` capabilities so gopls integrates with the existing nvim-cmp completion pipeline — no changes needed to `lsp-config.lua`
- Build step: `:lua require("go.install").update_all_sync()` — installs gopls and related binaries via mason

### Auto-imports on save
A `BufWritePre` autocmd on `*.go` calls `require("go.format").goimports()`, which runs both `gofmt` (formatting) and import organization atomically on every save.

### Keymaps (all `<leader>`-prefixed, consistent with existing style)
| Key | Action |
|---|---|
| `<leader>gt` | `:GoTest` — run tests for current package |
| `<leader>gtf` | `:GoTestFunc` — run test under cursor |
| `<leader>gta` | `:GoAddTest` — generate test for function under cursor |
| `<leader>gi` | `:GoImport` — manually trigger import organization |
| `<leader>gfs` | `:GoFillStruct` — fill struct with zero-value fields |
| `<leader>gii` | `:GoImpl` — generate interface implementation stubs |

---

## 2. Bug Fix: Remove duplicate `gitsigns.lua`

Both `lua/plugins/gitsigns.lua` and `lua/plugins/git-stuff.lua` define `vim-fugitive` + `gitsigns`. `gitsigns.lua` has no keymap config; `git-stuff.lua` has the working keymaps (`<leader>gp`, `<leader>gt`). Delete `gitsigns.lua`.

### Keymap conflict resolution
`<leader>gt` is used in `git-stuff.lua` for `Gitsigns toggle_current_line_blame`. This conflicts with the new `<leader>gt` for `:GoTest`. Remap the blame toggle to `<leader>gb` in `git-stuff.lua`.

---

## 3. `nvim-autopairs` (`lua/plugins/autopairs.lua` — new file)

- Plugin: `windwp/nvim-autopairs`
- Auto-closes `()`, `[]`, `{}`, `""`, `''`, ` `` `
- Enable nvim-cmp integration via `cmp.event:on("confirm_done", autopairs.on_confirm_done())` so confirmed completions don't double-insert closing characters

---

## 4. `which-key.nvim` (`lua/plugins/which-key.lua` — new file)

- Plugin: `folke/which-key.nvim`
- Shows a popup listing available keymaps when a prefix key is held
- Minimal config: just `require("which-key").setup()` — works out of the box with all existing keymaps

---

## 5. Relative line numbers (`lua/vim-options.lua` — modify)

Add `vim.wo.relativenumber = true` alongside the existing `vim.wo.number = true`. Shows absolute number on the current line, relative offsets elsewhere. Enables fast vertical motions (`5dd`, `10j`, etc.).

---

## 6. Remove stale window nav keymaps (`lua/vim-options.lua` — modify)

Remove the four `<C-h/j/k/l>` keymaps for `:wincmd`. They are immediately overridden by `nvim-tmux-navigation` and serve no purpose.

---

## 7. `lualine.nvim` (`lua/plugins/lualine.lua` — new file)

- Plugin: `nvim-lualine/lualine.nvim`
- Theme: `"gruvbox"` to match the existing colorscheme
- Shows: mode, filename, git branch (via gitsigns), LSP diagnostics, filetype, cursor position
- Default `lualine` sections are sufficient — no custom section config needed

---

## Files Changed

| File | Action |
|---|---|
| `lua/plugins/go.lua` | Create |
| `lua/plugins/autopairs.lua` | Create |
| `lua/plugins/which-key.lua` | Create |
| `lua/plugins/lualine.lua` | Create |
| `lua/plugins/gitsigns.lua` | Delete |
| `lua/plugins/git-stuff.lua` | Modify (`<leader>gt` → `<leader>gb`) |
| `lua/vim-options.lua` | Modify (add relativenumber, remove stale keymaps) |
