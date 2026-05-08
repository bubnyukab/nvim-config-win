# Neovim Config (Windows)

Lua config managed by [lazy.nvim](https://github.com/folke/lazy.nvim). Targets native Windows — no tmux dependency.

## Requirements

- Neovim 0.10+
- Git
- Node.js (for `swagger-ui-watcher` and LSP servers)
- Go toolchain (for Go development)
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)

## Keymaps

`<leader>` is `Space`.

### Navigation

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Move between splits |
| `<C-n>` | Toggle file tree (Neo-tree) |
| `<leader>bf` | Browse open buffers (Neo-tree float) |
| `-` | Open parent directory in Oil (float) |
| `<C-p>` | Find files (Telescope) |
| `<leader>fg` | Live grep |
| `<leader><leader>` | Recent files |
| `<leader>h` | Clear search highlight |

### LSP

| Key | Action |
|-----|--------|
| `K` | Hover docs |
| `<leader>gd` | Go to definition |
| `<leader>gr` | Find references |
| `<leader>ca` | Code actions |
| `<leader>gf` | Format buffer |

### Git

| Key | Action |
|-----|--------|
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Toggle line blame |
| `:G ...` | Fugitive git commands |

### Testing (vim-test)

| Key | Action |
|-----|--------|
| `<leader>t` | Run nearest test |
| `<leader>T` | Run test file |
| `<leader>a` | Run test suite |
| `<leader>l` | Re-run last test |
| `<leader>tv` | Visit test file |

Tests run in a native Neovim terminal (no tmux required).

### Go (go.nvim)

| Key | Action |
|-----|--------|
| `<leader>gt` | Run package tests |
| `<leader>gtf` | Run function under cursor |
| `<leader>gta` | Generate test for function |
| `<leader>gi` | Add/tidy imports |
| `<leader>gfs` | Fill struct fields |
| `<leader>gii` | Implement interface |

`goimports` runs automatically on save for `.go` files.

### Completion

| Key | Action |
|-----|--------|
| `<C-Space>` | Trigger completion |
| `<CR>` | Confirm selection |
| `<C-e>` | Abort completion |
| `<C-b/f>` | Scroll docs |

## Plugins

| Plugin | Purpose |
|--------|---------|
| lazy.nvim | Plugin manager |
| alpha-nvim | Start screen |
| neo-tree.nvim | File tree |
| oil.nvim | Directory editing / file manager |
| telescope.nvim | Fuzzy finder |
| nvim-treesitter | Syntax highlighting & indentation |
| nvim-lspconfig + mason | LSP servers (TS, Ruby, HTML, Lua) |
| nvim-cmp + LuaSnip | Completion & snippets |
| none-ls.nvim | Formatting (stylua, prettier, rubocop) |
| go.nvim | Go IDE features |
| vim-test | Test runner |
| gitsigns.nvim | Inline git diff & blame |
| vim-fugitive | Full git integration |
| lualine.nvim | Status line |
| which-key.nvim | Keymap hints |
| nvim-autopairs | Auto-close brackets/quotes |
| swagger-preview.nvim | Swagger UI preview |

## Colorscheme

Uses `habamax` (built-in, no plugin required) with a transparent background.

## LSP Servers

Managed by Mason, auto-installed on first launch:

- `ts_ls` — TypeScript / JavaScript
- `solargraph` — Ruby
- `html` — HTML
- `lua_ls` — Lua

## Notes

- No tmux dependency. Split navigation uses native `<C-w>` motions.
- `guihua.lua` skips its native `make` build step on Windows (fzy fuzzy matcher falls back gracefully).
