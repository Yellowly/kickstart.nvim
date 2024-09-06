vim.keymap.set('i', '<C-f>', '<esc>/', { desc = 'Find in file' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window', silent = true })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window', silent = true })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window', silent = true })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window', silent = true })

-- Other stuff
-- save file, undo/redo
vim.keymap.set('i', '<C-z>', '<esc>ui', { desc = 'Undo' })
vim.keymap.set('i', '<C-y>', '<esc><C-r>i', { desc = 'Redo' })
vim.keymap.set('i', '<C-s>', '<cmd>w<cr>', { desc = 'Save file' })
vim.keymap.set('n', '<C-s>', '<cmd>w<cr>', { desc = 'Save file' })

-- resize windows
vim.keymap.set('n', '<C-Up>', '<cmd>resize -2<cr>', { silent = true })
vim.keymap.set('n', '<C-Down>', '<cmd>resize +2<cr>', { silent = true })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { silent = true })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { silent = true })

-- select / copypaste
vim.keymap.set('i', '<S-Right>', '<Right><esc>v', {})
vim.keymap.set('i', '<S-Left>', '<esc>v', {})
vim.keymap.set('i', '<S-Up>', '<esc>vk', {})
vim.keymap.set('i', '<S-Down>', '<esc>vj', {})
vim.keymap.set('v', '<C-c>', 'y', {})
vim.keymap.set('i', '<C-v>', '<esc>pi', {})

-- quit
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>', { desc = 'Quit' })
vim.keymap.set('n', '<leader><S-q>', '<cmd>qa<cr>', { desc = 'Quit all' })

-- alternate tabs
-- vim.keymap.set('i', '<C-l>', '<esc>gti', {})
vim.keymap.set('n', '<C-I>', 'gt', {})
vim.keymap.set('n', '<S-t>', '<C-t><cmd>-tabnext<cr>', {})
vim.keymap.set('n', '<S-I>', '<cmd>tabp<cr>', {})

-- explorer
vim.keymap.set('n', '<leader>e', '<cmd>Lexplore<cr><cmd>vertical resize 30<cr>', { desc = 'Toggles the explorer' })
-- vim.keymap.set('n','<leader>e','<cmd>NvimTreeToggle<cr>',{desc="Open file explorer",silent=true})

-- terminal
vim.keymap.set('i', '<C-t>', '', {
  callback = function()
    ToggleTerm(8)
  end,
  desc = 'Toggle the terminal',
})
vim.keymap.set('n', '<leader>t', '', {
  desc = 'Toggle the terminal',
  callback = function()
    ToggleTerm(12)
  end,
})
vim.keymap.set('t', '<C-t>', '', {
  desc = 'Toggle the terminal',
  callback = function()
    ToggleTerm(8)
  end,
})

vim.g.term_buf = -1
vim.g.term_win = -1
function ToggleTerm(height)
  if vim.api.nvim_win_is_valid(vim.g.term_win) then
    vim.api.nvim_win_hide(vim.g.term_win)
    vim.g.term_win = -1
  else
    vim.cmd(height .. 'sp')
    if vim.g.term_buf ~= -1 then
      vim.cmd('buffer ' .. vim.g.term_buf)
    else
      vim.cmd 'term'
      vim.g.term_buf = vim.api.nvim_get_current_buf()
      vim.cmd 'set nonu'
      vim.api.nvim_buf_set_name(vim.g.term_buf, 'Terminal')
      -- vim.api.nvim_buf_set_option(vim.g.term_buf, 'buftype', 'nofile')
    end
    vim.g.term_win = vim.api.nvim_get_current_win()
  end
end

-- commenting
vim.keymap.set('i', '<C-/>', '<esc>gcci', { desc = 'Comment line' })
vim.keymap.set('i', '<C-.>', '<esc>gcci', { desc = 'Comment line' })
vim.keymap.set('n', '<C-/>', '<esc>gcc', { desc = 'Comment line' })

-- vim.keymap.set('i', '(', '()<Left>', { desc = 'adds another paren' })
-- vim.keymap.set('i', '{', '{}<Left>', { desc = 'adds another bracket' })
--
