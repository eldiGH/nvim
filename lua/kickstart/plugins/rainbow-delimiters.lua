-- Rainbow brackets: tint matching (), [], {} by nesting depth so pairs are easy
-- to match visually. Kept deliberately subtle (3 muted tones that cycle).
-- https://github.com/HiPhish/rainbow-delimiters.nvim

vim.pack.add { 'https://github.com/HiPhish/rainbow-delimiters.nvim' }

-- A muted, low-saturation palette for the bracket levels. Re-applied on every
-- colorscheme load so it survives theme switches (<leader>tc).
local function set_rainbow_hl()
  vim.api.nvim_set_hl(0, 'RainbowDelimiterBlue', { fg = '#61afef' }) -- onedark blue
  vim.api.nvim_set_hl(0, 'RainbowDelimiterGreen', { fg = '#98c379' }) -- onedark green
  vim.api.nvim_set_hl(0, 'RainbowDelimiterViolet', { fg = '#c678dd' }) -- onedark violet
end
set_rainbow_hl()
vim.api.nvim_create_autocmd('ColorScheme', { callback = set_rainbow_hl })

-- The plugin auto-activates once loaded; it just reads this global for config.
vim.g.rainbow_delimiters = {
  strategy = {
    [''] = require('rainbow-delimiters').strategy['global'],
  },
  query = {
    [''] = 'rainbow-delimiters',
  },
  -- Cycle through only these 3 muted tones, so deep nesting repeats calmly
  -- instead of turning into a full rainbow. Add more groups for more distinct levels.
  highlight = {
    'RainbowDelimiterBlue',
    'RainbowDelimiterGreen',
    'RainbowDelimiterViolet',
  },
}
