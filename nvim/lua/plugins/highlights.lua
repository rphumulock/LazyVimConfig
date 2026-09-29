-- LazyVim's default colorscheme is tokyonight, which draws the lines between
-- window splits (the WinSeparator highlight) very faint. This brightens them so
-- section/split boundaries are easy to see on a projector during demos.
--
-- tokyonight exposes an on_highlights(hl, c) hook where `c` is the active
-- palette; we repaint WinSeparator to a mid-gray and bold it. To change the
-- intensity, swap c.fg_dark for c.fg (brightest) or a literal hex like "#565f89".
return {
  {
    "folke/tokyonight.nvim",
    opts = {
      on_highlights = function(hl, c)
        hl.WinSeparator = { fg = c.fg_dark, bold = true }
      end,
    },
  },
}
