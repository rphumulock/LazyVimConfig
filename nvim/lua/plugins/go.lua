-- LazyVim's lang.go extra formats `.go` on save with `goimports` then `gofumpt`
-- (see lazyvim/plugins/extras/lang/go.lua). Neither wraps long lines — gofmt and
-- its stricter cousin gofumpt deliberately leave line length alone, which is the
-- Go team's stated position. `golines` (github.com/segmentio/golines) fills that
-- gap: it splits over-long function calls, signatures, struct literals and chains
-- at a configurable column, then defers to a base formatter to tidy the result.
-- This file adds golines to the front of the conform chain and installs it via
-- Mason (same source LazyVim uses for goimports/gofumpt), so no extra `go install`
-- is needed outside Neovim.
return {
  -- Mason provides the goimports/gofumpt binaries the go extra relies on; add
  -- golines alongside them so the whole formatter chain comes from one place and
  -- gets installed on the same first-launch Mason sync.
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "golines" } },
  },
  -- Prepend golines to the go formatter list. conform runs formatters left to
  -- right, so golines wraps first and goimports/gofumpt normalise the output.
  -- This list replaces (not merges with) the extra's { goimports, gofumpt }, so
  -- both are restated here. `-m 100` sets the max column; raise it to taste.
  -- golines can only break lines it understands (args, chains, literals) — a long
  -- string or single identifier can't be split and is left as-is, by design.
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        go = { "golines", "goimports", "gofumpt" },
      },
      formatters = {
        golines = {
          prepend_args = { "-m", "100" },
        },
      },
    },
  },
}
