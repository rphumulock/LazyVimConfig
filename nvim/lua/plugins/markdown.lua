-- Markdown is format-only: prettier reformats on save, the linter is off, and
-- there are no markdownlint rules to curate (no ~/.markdownlint-cli2.yaml).
--
-- Why prettier and not markdownlint-cli2 --fix: LazyVim's lang.markdown extra
-- gates the markdownlint-cli2 *formatter* on there being markdownlint
-- *diagnostics* in the buffer (its conform `condition` returns `#diag > 0`). So
-- you can't "just fix on save" without also running the linter and eating its
-- squiggles — the two are coupled. prettier has no such gate: it's listed first
-- in LazyVim's default markdown formatter list and runs unconditionally, needs no
-- rules config, and leaves fenced code blocks (Go/Make hard tabs) untouched.
return {
  -- Turn markdown linting off — no diagnostics; the formatter does the work.
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = {}
      opts.linters_by_ft["markdown.mdx"] = {}
    end,
  },
  -- Format markdown with prettier only — drop markdownlint-cli2 (and its
  -- diagnostic-gated condition). markdown-toc stays for <!-- toc --> blocks.
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.markdown = { "prettier", "markdown-toc" }
      opts.formatters_by_ft["markdown.mdx"] = { "prettier", "markdown-toc" }
    end,
  },
  -- LazyVim lists prettier first for markdown but only ensure-installs
  -- markdownlint-cli2 + markdown-toc — so install prettier too.
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "prettier" } },
  },
}
