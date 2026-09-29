-- Show dotfiles and gitignored files in the snacks explorer and file pickers.
--
-- LazyVim's snacks pickers hide both by default, and they are TWO SEPARATE
-- filters: `hidden` covers dotfiles, `ignored` covers anything matched by
-- .gitignore. A path that is both — .claude/, .config/, .github/workflows in a
-- repo that ignores them — stays invisible unless both are on, which is
-- confusing enough to look like a broken config.
--
-- Concretely: Claude Code worktrees live in <repo>/.claude/worktrees/, and
-- repos here commonly carry `.claude/` in .gitignore. Without this, that whole
-- tree is unreachable from the explorer and from <leader>ff.
--
-- These two flags map straight onto the search backend's arguments — `hidden`
-- adds --hidden and `ignored` adds --no-ignore for rg/fd
-- (snacks/picker/source/files.lua). Toggle them per-session instead with H
-- (hidden) and I (ignored) in the explorer, or <A-h>/<A-i> in any picker.
--
-- Trade-off: `ignored = true` also surfaces build output and data dirs that
-- .gitignore exists to hide (bin/, _data/, _logs/, node_modules/). Add noisy
-- paths to `exclude` below rather than turning the flags back off — being able
-- to see .claude/ and other dot-directories is worth more day to day.
return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = { hidden = true, ignored = true },
          files = { hidden = true, ignored = true },
          grep = { hidden = true, ignored = true },
        },
        -- Always skip these, even with hidden/ignored on. .git in particular
        -- is thousands of objects and never something you want to open.
        exclude = { ".git", "node_modules", "_data", "_logs" },
      },
    },
  },
}
