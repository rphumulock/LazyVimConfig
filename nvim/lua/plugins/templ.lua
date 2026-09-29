-- templ (github.com/a-h/templ) is HTML templating codegen for Go. The `templ`
-- binary must be installed separately (go install) and available on PATH via
-- the Go bin dir — it ships both the formatter (`templ fmt`) and the
-- language server (`templ lsp`). LazyVim's lang.go extra does NOT wire templ in,
-- so out of the box `.templ` files open as plaintext. This file adds the three
-- missing pieces: filetype detection, the treesitter parser, and the LSP.
return {
  -- Neovim core has no filetype rule for `*.templ`, and nvim-lspconfig's templ
  -- server only declares `filetypes = { "templ" }` without registering the
  -- extension — so nothing ever sets the buffer's filetype. Do it ourselves;
  -- treesitter highlighting and the LSP both key off this.
  {
    "LazyVim/LazyVim",
    init = function()
      vim.filetype.add({ extension = { templ = "templ" } })
    end,
  },
  -- Install the templ treesitter parser. nvim-treesitter already bundles the
  -- highlight/injection/fold queries (the injections light up the embedded
  -- HTML/CSS/JS and the Go expressions inside templates); only the parser
  -- itself needs fetching.
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "templ")
    end,
  },
  -- Enable the templ language server (cmd `templ lsp`). mason = false because
  -- the binary is installed separately via `go install`; without this LazyVim
  -- would try to Mason-install a second copy.
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        templ = { mason = false },
      },
    },
  },
  -- Format `.templ` on save with `templ fmt` (conform ships this formatter),
  -- matching the format-on-save behaviour the Go extra sets up for `.go`.
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.templ = { "templ" }
    end,
  },
}
