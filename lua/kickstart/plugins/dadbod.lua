-- vim-dadbod: interact with databases (Postgres, MySQL, SQLite, ...) from Neovim.
--  - vim-dadbod            core engine (:DB command, runs queries)
--  - vim-dadbod-ui         drawer UI to browse connections/tables and write queries
--  - vim-dadbod-completion completion source for SQL buffers (tables, columns, ...)
-- https://github.com/tpope/vim-dadbod
-- https://github.com/kristijanhusak/vim-dadbod-ui

-- NOTE: dadbod-ui reads its `vim.g.db_ui_*` settings when it loads, so set them
-- BEFORE vim.pack.add (which puts the plugin on the runtimepath immediately).

-- Use nerd-font icons in the drawer
vim.g.db_ui_use_nerd_fonts = 1

-- Where saved queries and connections live (default: ~/.local/share/db_ui)
vim.g.db_ui_save_location = vim.fn.stdpath 'data' .. '/db_ui'

-- Don't run a query automatically every time the query buffer is saved with :w.
-- Execute explicitly with <leader>W or the buffer-local mappings instead.
vim.g.db_ui_execute_on_save = 0

vim.pack.add {
  'https://github.com/tpope/vim-dadbod',
  'https://github.com/kristijanhusak/vim-dadbod-ui',
  'https://github.com/kristijanhusak/vim-dadbod-completion',
}

-- [[ Keymaps ]] (see also which-key group '<leader>D' registered in init.lua)
vim.keymap.set('n', '<leader>Db', '<Cmd>DBUIToggle<CR>', { desc = '[D]atabase: toggle [B]rowser (drawer)' })
vim.keymap.set('n', '<leader>Df', '<Cmd>DBUIFindBuffer<CR>', { desc = '[D]atabase: connect current buffer ([F]ind)' })
vim.keymap.set('n', '<leader>Da', '<Cmd>DBUIAddConnection<CR>', { desc = '[D]atabase: [A]dd connection' })

-- In dadbod query buffers, dadbod-ui provides buffer-local <Plug> mappings.
-- Bind query execution to something memorable in normal + visual mode.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('kickstart-dadbod', { clear = true }),
  pattern = { 'sql', 'mysql', 'plsql' },
  callback = function(event)
    -- Run the whole buffer (normal mode) or just the selection (visual mode)
    vim.keymap.set('n', '<leader>W', '<Plug>(DBUI_ExecuteQuery)', { buffer = event.buf, desc = 'Database: execute query' })
    vim.keymap.set('v', '<leader>W', '<Plug>(DBUI_ExecuteQuery)', { buffer = event.buf, desc = 'Database: execute selected query' })
  end,
})
