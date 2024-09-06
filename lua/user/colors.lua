vim.api.nvim_set_option_value('termguicolors', true, {})
vim.cmd.colorscheme 'slate'
vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = '#423f3e', fg = '#f7cc31' })
vim.api.nvim_set_hl(0, 'VertSplit', { bg = '#423f3e', fg = '#f7cc31' })
vim.api.nvim_set_hl(0, 'NormalNC', { bg = '#2c2a29' })
vim.api.nvim_set_hl(0, 'cleared', { bg = '#2c2a29' })
vim.api.nvim_set_hl(0, 'Normal', { bg = '#2c2a29' })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = '#2c2a29' })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#302e2d' })
vim.api.nvim_set_hl(0, 'CursorLineNR', { bg = '#302e2d' })
vim.api.nvim_set_hl(0, 'Identifier', { fg = '#ebd5a4' })
vim.api.nvim_set_hl(0, 'Function', { fg = '#a2d0de' })
vim.api.nvim_set_hl(0, 'String', { fg = '#b0db93' })
vim.api.nvim_set_hl(0, 'Statement', { fg = '#db8a86', bold = true })
vim.api.nvim_set_hl(0, 'Special', { fg = '#f7e06d' })
vim.api.nvim_set_hl(0, 'Structure', { fg = '#e39674' })
-- vim.api.nvim_set_hl(0, '@variable', { fg = '#ffaa88' })
vim.api.nvim_set_hl(0, 'Operator', { fg = '#e37152' })

vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Highlight self differently from other variables in rust',
  pattern = '*.rs',
  callback = function()
    vim.api.nvim_set_hl(0, '@variable', { fg = '#ffaa88' })
  end,
})
vim.api.nvim_create_autocmd('BufLeave', {
  desc = 'Highlight self differently from other variables in rust',
  pattern = '*.rs',
  callback = function()
    vim.api.nvim_set_hl(0, '@variable', { link = 'Identifier' })
  end,
})
