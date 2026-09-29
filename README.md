# LazyVim Config

My standalone [LazyVim](https://www.lazyvim.org/) configuration, extracted from
`rphumulock/DevEnvironment`.

The installer only installs the Neovim configuration. It does **not** install
Neovim, Git, Go, Node.js, or other system dependencies.

## Install

Requirements:

- Git
- Neovim 0.11.2 or newer
- A compiler and the usual LazyVim prerequisites

Clone the repository somewhere other than `~/.config/nvim`, then run the
installer:

```bash
gh repo clone rphumulock/LazyVimConfig
cd LazyVimConfig
./install.sh
nvim
```

On first launch, lazy.nvim installs the plugins and Mason installs most language
tools. Leave Neovim open until those installs finish.

The default destination is `~/.config/nvim` (or
`$XDG_CONFIG_HOME/nvim`). If a config already exists, the installer moves it to
a timestamped backup such as `~/.config/nvim.backup.20260929-163000` before
installing this one.

Install to a different path with either form:

```bash
./install.sh --target /path/to/nvim
NVIM_CONFIG_DIR=/path/to/nvim ./install.sh
```

## Included setup

- LazyVim extras for Go, Python, JSON, YAML, Markdown, Docker, and Harpoon2
- Prettier-only Markdown formatting with markdownlint diagnostics disabled
- `templ` filetype, Treesitter, LSP, and formatting support
- Go formatting through `golines`, `goimports`, and `gofumpt`
- Visible dotfiles and gitignored files in Snacks explorer/pickers
- Brighter Tokyo Night split separators
- Spell checking disabled

The `templ` language server/formatter is intentionally expected on `PATH`
rather than installed through Mason. Install it separately when needed:

```bash
go install github.com/a-h/templ/cmd/templ@latest
```

## Updating the config

Edit files under [`nvim/`](nvim/), commit them, and rerun `./install.sh` to
replace the installed copy. `nvim/lazy-lock.json` records the currently resolved
plugin versions; copy back and commit lockfile changes after intentionally
updating plugins.

## Layout

```text
.
├── install.sh
└── nvim/                 # copied to ~/.config/nvim
    ├── init.lua
    ├── lazy-lock.json
    ├── lazyvim.json
    └── lua/
        ├── config/
        └── plugins/
```
