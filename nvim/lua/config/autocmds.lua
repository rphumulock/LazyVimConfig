-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable LazyVim's auto spell check (and wrap) for text/markdown/gitcommit/etc.
-- This file loads on VeryLazy, after LazyVim has registered its default
-- autocmds, so the group exists by the time we delete it. The global default is
-- set off in options.lua; deleting this group stops it being re-enabled per-buffer.
pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_wrap_spell")
