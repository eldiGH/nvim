-- diffview.nvim — review all your changes on one tab page:
-- a file panel on the left, syntax-highlighted side-by-side diffs on the right.
-- Because the diffs are real Neovim buffers, treesitter highlighting, your
-- colorscheme, and even LSP all work inside them.
-- https://github.com/sindrets/diffview.nvim

vim.pack.add {
  { src = 'https://github.com/sindrets/diffview.nvim' },
  'https://github.com/nvim-lua/plenary.nvim', -- already pulled by telescope/neo-tree; vim.pack dedups
}

require('diffview').setup {
  hooks = {
    -- Neovim's diff is symmetric: a deleted line shows up as an "add" in whichever
    -- side still has it, so by default deletions look GREEN in the left/old pane.
    -- This hook remaps the highlights PER WINDOW: in the left window (ctx.symbol
    -- 'a') we render those "adds" as deletions (red, via DiffviewDiffAddAsDelete);
    -- the right window keeps additions green. Result: git-style red-left/green-right.
    diff_buf_win_enter = function(_, _, ctx)
      if ctx.layout_name:match '^diff2' then
        if ctx.symbol == 'a' then -- left / old version → render removed & changed lines red
          vim.opt_local.winhighlight = table.concat({
            'DiffAdd:DiffviewDiffAddAsDelete',
            'DiffChange:DiffviewDiffAddAsDelete',
            'DiffText:DiffviewDiffDeleteText',
            'DiffDelete:DiffviewDiffDelete',
          }, ',')
        elseif ctx.symbol == 'b' then -- right / new version → keep additions green, filler gray
          vim.opt_local.winhighlight = 'DiffDelete:DiffviewDiffDelete'
        end
      end
    end,
  },
}

-- catppuccin's diffview integration defines these groups as dim gray, which beats
-- a `custom_highlights` override. So force the colors we want HERE (after catppuccin
-- has loaded) and re-apply on every colorscheme change (e.g. via <leader>tc).
local function set_diff_highlights()
  vim.api.nvim_set_hl(0, 'DiffviewDiffAddAsDelete', { bg = '#502934' }) -- removed/changed lines (left)
  vim.api.nvim_set_hl(0, 'DiffviewDiffDeleteText', { bg = '#6b3641' }) -- changed words within them
  vim.api.nvim_set_hl(0, 'DiffviewDiffDelete', { fg = '#585b70', bg = 'NONE' }) -- gray ╱ filler
end
set_diff_highlights()
vim.api.nvim_create_autocmd('ColorScheme', { callback = set_diff_highlights })

-- <leader>g d → open a review of ALL current changes (working tree vs index/HEAD)
vim.keymap.set('n', '<leader>gd', '<Cmd>DiffviewOpen<CR>', { desc = '[G]it [D]iff: review all changes' })

-- <leader>g h → browse the commit history of the CURRENT file ( % = current file )
vim.keymap.set('n', '<leader>gh', '<Cmd>DiffviewFileHistory %<CR>', { desc = '[G]it file [H]istory' })
