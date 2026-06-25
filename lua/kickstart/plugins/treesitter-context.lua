-- treesitter-context: "sticky scroll" — pins the enclosing scope (fn / impl /
-- match / loop) to the top of the window as you scroll through a long body,
-- just like VS Code's sticky headers. The pinned lines are clickable to jump up.
-- https://github.com/nvim-treesitter/nvim-treesitter-context

vim.pack.add { 'https://github.com/nvim-treesitter/nvim-treesitter-context' }

require('treesitter-context').setup {
  max_lines = 5, -- cap how many lines get pinned, so deep nesting can't eat the screen (0 = unlimited)
  multiline_threshold = 1, -- collapse a multi-line fn signature down to its first line
  mode = 'cursor', -- base the context on the cursor line ('topline' is closer to VS Code)
  trim_scope = 'outer', -- if over max_lines, drop the outermost scopes first
}

-- Toggle the sticky header on/off
vim.keymap.set('n', '<leader>tx', '<cmd>TSContext toggle<cr>', { desc = '[T]oggle conte[x]t (sticky scroll)' })

-- Jump UP to the context header (the enclosing fn/impl line that's pinned)
vim.keymap.set('n', '<leader>tu', function()
  require('treesitter-context').go_to_context(vim.v.count1)
end, { desc = 'Jump [u]p to context header' })
