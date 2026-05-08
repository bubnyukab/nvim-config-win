# nvim-config-win

A Neovim configuration for Windows, built on [lazy.nvim](https://github.com/folke/lazy.nvim).

## Requirements

- [Neovim](https://neovim.io/) >= 0.9
- [Git](https://git-scm.com/)
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- Node.js (for `ts_ls` and `prettier`)
- Go (for Go development features)
- Ruby / Bundler (for `solargraph`, `rubocop`, `erb_lint`)

## Installation

```
git clone https://github.com/bubnyukab/nvim-config-win %LOCALAPPDATA%\nvim
```

Open Neovim — lazy.nvim will bootstrap itself and install all plugins automatically.

## Plugins

| Plugin | Purpose |
|--------|---------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP client & server installer |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) + LuaSnip | Autocompletion & snippets |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting & indentation |
| [Telescope](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File tree |
| [oil.nvim](https://github.com/stevearc/oil.nvim) | File manager as a buffer |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Status line |
| [alpha-nvim](https://github.com/goolord/alpha-nvim) | Dashboard / start screen |
| [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim) | Formatting & diagnostics (stylua, prettier, rubocop, erb_lint) |
| [go.nvim](https://github.com/ray-x/go.nvim) | Go development (tests, imports, struct fill, interface impl) |
| [vim-fugitive](https://github.com/tpope/vim-fugitive) | Git commands |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git hunk preview & blame |
| [vim-test](https://github.com/vim-test/vim-test) + [vimux](https://github.com/preservim/vimux) | Test runner |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-close brackets & quotes |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keybinding hints |
| [nvim-tmux-navigation](https://github.com/alexghergh/nvim-tmux-navigation) | Seamless tmux/nvim pane navigation |
| [swagger-preview.nvim](https://github.com/vinnymeller/swagger-preview.nvim) | OpenAPI / Swagger preview |

**Colorscheme:** `habamax` (built-in)

## LSP Servers

Configured via mason-lspconfig with auto-install enabled:

- `ts_ls` — TypeScript / JavaScript
- `lua_ls` — Lua
- `html` — HTML
- `solargraph` — Ruby

## Keymaps

### General

| Key | Action |
|-----|--------|
| `<leader>h` | Clear search highlight |
| `<leader>gf` | Format buffer (LSP) |

### LSP

| Key | Action |
|-----|--------|
| `K` | Hover documentation |
| `<leader>gd` | Go to definition |
| `<leader>gr` | Go to references |
| `<leader>ca` | Code action |

### Telescope

| Key | Action |
|-----|--------|
| `<C-p>` | Find files |
| `<leader>fg` | Live grep |
| `<leader><leader>` | Recent files |

### File Navigation

| Key | Action |
|-----|--------|
| `<C-n>` | Toggle Neo-tree (left) |
| `<leader>bf` | Neo-tree buffer list (float) |
| `-` | Oil float (edit directory) |

### Git

| Key | Action |
|-----|--------|
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Toggle line blame |

### Go

| Key | Action |
|-----|--------|
| `<leader>gt` | Run tests |
| `<leader>gtf` | Run test for current function |
| `<leader>gta` | Add test for current function |
| `<leader>gi` | Add/organize imports |
| `<leader>gfs` | Fill struct |
| `<leader>gii` | Implement interface |

### Testing (vim-test)

| Key | Action |
|-----|--------|
| `<leader>t` | Run nearest test |
| `<leader>T` | Run tests in file |
| `<leader>a` | Run full test suite |
| `<leader>l` | Re-run last test |
| `<leader>g` | Visit last test file |

## Editor Settings

- 4-space indentation, `expandtab`
- `<Space>` as leader key
- Line numbers + relative line numbers
- No swap files
- Transparent background
