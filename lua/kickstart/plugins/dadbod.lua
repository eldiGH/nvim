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

-- Drawer width in columns (default: 40, too narrow for schema-qualified names).
-- Read every time the drawer opens; `:vertical resize N` overrides it for one
-- session. The drawer is `winfixwidth`, so other splits will not squash it.
vim.g.db_ui_winwidth = 60

-- Where saved queries and connections live (default: ~/.local/share/db_ui)
vim.g.db_ui_save_location = vim.fn.stdpath 'data' .. '/db_ui'

-- Don't run a query automatically every time the query buffer is saved with :w.
-- Execute explicitly with <leader>W or the buffer-local mappings instead.
vim.g.db_ui_execute_on_save = 0

-- Extra entries under each table in the drawer. The built-in Postgres helpers
-- are `SELECT *` over information_schema: one wide result per aspect (columns,
-- indexes, keys), and none at all for CHECK constraints. dadbod runs queries
-- through `psql -f`, so psql's own `\d` works here and shows columns, types,
-- nullability, defaults, indexes and every constraint in one screen.
-- Plain `\d`, not `\d+`: on a TimescaleDB hypertable the `+` lists every chunk.
-- The `postgresql` key also covers `postgres://` URLs (dadbod-ui maps the two).
vim.g.db_ui_table_helpers = {
  postgresql = { Describe = [[\d {optional_schema}"{table}"]] },
}

-- Schemas left out of the drawer (each entry is a Vim regex, tested with
-- match()). Postgres lists its own catalogs as schemas, and TimescaleDB adds
-- seven more, one holding every chunk; in practice only `public` matters.
-- `timescaledb_information` stays visible: its views (hypertables, chunks,
-- jobs) are the supported way to inspect TimescaleDB's own state.
vim.g.db_ui_hide_schemas = {
  '^pg_',
  '^information_schema$',
  '^_timescaledb_',
  '^timescaledb_experimental$',
}

-- Run a table helper as soon as it is opened, rather than only writing its
-- query into a buffer. Every helper is a read-only SELECT or psql describe.
vim.g.db_ui_auto_execute_table_helpers = 1

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

    -- Save the query under a name, into g:db_ui_save_location.
    -- Upstream binds this to <leader>W, which the execute mapping above takes
    -- over (this autocmd runs after the plugin's ftplugin/sql.vim), so without
    -- a mapping here saving would have no key at all.
    vim.keymap.set('n', '<leader>Ds', '<Plug>(DBUI_SaveQuery)', { buffer = event.buf, desc = 'Database: [s]ave query' })
  end,
})
