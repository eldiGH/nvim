-- Welcome screen (mini.starter) + disable netrw, so opening a directory shows
-- a dashboard instead of the built-in netrw file listing.
-- mini.starter ships inside mini.nvim, which is already added in init.lua.

-- Kill netrw entirely (its directory listing is what popped up on `nvim .`).
-- Safe here: all of init.lua runs before the bundled netrw plugin loads.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local starter = require 'mini.starter'

starter.setup {
  -- Default header is a time-based greeting ("Good morning", ...).
  items = {
    starter.sections.recent_files(8, false), -- 8 most recent files (2nd arg = cwd-only)
    {
      { name = 'Find file', action = 'Telescope find_files', section = 'Actions' },
      { name = 'Live grep', action = 'Telescope live_grep', section = 'Actions' },
      { name = 'New file', action = 'enew', section = 'Actions' },
      { name = 'Config', action = 'edit $MYVIMRC', section = 'Actions' },
      { name = 'Quit', action = 'qall', section = 'Actions' },
    },
  },
  content_hooks = {
    starter.gen_hook.adding_bullet(), -- prefix each item with a bullet
    starter.gen_hook.aligning('center', 'center'), -- center it in the window
  },
}

-- `nvim` with no args opens Starter automatically (mini's default). This extra
-- autocmd also shows it when you launch on a directory (e.g. `nvim .`),
-- replacing the otherwise-empty directory buffer.
vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('kickstart-starter-on-dir', { clear = true }),
  callback = function()
    if vim.fn.argc() ~= 1 then return end -- only a single argument
    local arg = vim.fn.argv(0)
    if vim.fn.isdirectory(arg) ~= 1 then return end -- ...and it must be a directory
    local dir_buf = vim.api.nvim_get_current_buf()
    vim.fn.chdir(arg) -- make it the cwd, so find_files/grep are scoped to the project
    starter.open()
    pcall(vim.api.nvim_buf_delete, dir_buf, { force = true }) -- drop the leftover dir buffer
  end,
})
