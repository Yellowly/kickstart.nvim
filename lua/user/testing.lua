vim.g.buf_list_buf = -1
vim.g.buf_list_win = -1
BufListBufs = {}
BufListCurr = 0
function ShowBufs()
  local start_win = vim.api.nvim_get_current_win()
  local buf = vim.g.buf_list_buf
  if vim.g.buf_list_buf == -1 then
    vim.g.buf_list_buf = vim.api.nvim_create_buf(false, true)
    buf = vim.g.buf_list_buf
    vim.api.nvim_buf_set_name(buf, 'Buffers')
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'swapfile', false)
    vim.api.nvim_buf_set_option(buf, 'buflisted', false)
    vim.api.nvim_buf_set_option(buf, 'filetype', 'bufslist')
    vim.api.nvim_set_keymap('n', '<tab>', '', {
      callback = function()
        ToggleBuf(1)
      end,
    })
    vim.api.nvim_set_keymap('n', '<S-tab>', '', {
      callback = function()
        ToggleBuf(-1)
      end,
    })
  end
  vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  -- vim.api.nvim_buf_set_lines(buf, 0, -1, true, ["test", "text"])
  local buf_list = BufsList()
  BufListBufs = buf_list[5]
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, { buf_list[2] })
  local curr = vim.api.nvim_win_get_buf(start_win)
  if buf_list[3][curr] ~= nil then
    vim.api.nvim_buf_add_highlight(buf, -1, 'WinSeparator', 0, buf_list[3][curr], buf_list[3][curr] + vim.fs.basename(buf_list[1][curr]):len() + 2)
    BufListCurr = buf_list[4][curr]
  end
  if not vim.api.nvim_win_is_valid(vim.g.buf_list_win) then
    vim.cmd 'above sp'
    vim.cmd 'resize 1'
    vim.cmd 'set nonu'
    vim.cmd 'set winfixheight'
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
    vim.g.buf_list_win = win
  elseif vim.api.nvim_win_get_buf(vim.g.buf_list_win) ~= buf then
    vim.api.nvim_win_set_buf(vim.g.buf_list_win, buf)
  end
  vim.api.nvim_set_current_win(start_win)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  -- optional: change highlight, otherwise Pmenu is used
  -- vim.api.nvim_set_option_value('winhl', 'Normal:MyHighlight', {'win': win})
end

function ToggleBuf(n)
  local win = vim.api.nvim_get_current_win()
  local next_buf = BufListBufs[BufListCurr + n]
  if next_buf == nil then
    next_buf = BufListBufs[n < 0 and #BufListBufs or 1]
  end
  vim.api.nvim_win_set_buf(win, next_buf)
end

function BufsList()
  local res = {}
  local formatted_res = ''
  local idxs = {}
  local bufids = {}
  local bufs = {}
  local total_idx = 0
  local iter = 1
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= nil and name:find('.', -5, true) ~= nil then
        local formatted_name = ' ' .. (name:sub(1, 2) == 'C:' and vim.fs.basename(name) or name) .. ' '
        table.insert(res, buf, name)
        formatted_res = formatted_res .. formatted_name
        -- table.insert(formatted_res, buf, formatted_name)
        table.insert(idxs, buf, total_idx)
        table.insert(bufs, buf)
        table.insert(bufids, buf, iter)
        iter = iter + 1
        total_idx = total_idx + string.len(formatted_name)
      end
    end
  end
  table.insert(idxs, -1)
  --print(formatted_res[1] .. ' ' .. formatted_res[2] .. ' ' .. formatted_res[3] .. ' ' .. formatted_res[4])
  return { res, formatted_res, idxs, bufids, bufs }
end

vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Update BufList when changing buf',
  pattern = '*.*',
  callback = function()
    ShowBufs()
  end,
})

vim.g.explorer_buf = -1
vim.g.explorer_win = -1
vim.g.non_explr_win = -1

BExplorerDir = { [1] = false, [2] = {} }

function BetterExplorer()
  local buf = vim.g.explorer_buf
  if vim.g.explorer_buf == -1 then
    vim.g.explorer_buf = vim.api.nvim_create_buf(false, true)
    buf = vim.g.explorer_buf
    vim.api.nvim_buf_set_keymap(vim.g.explorer_buf, 'n', '<cr>', '', {
      callback = function()
        BetterExplorerSelect()
      end,
    })
  end
  vim.g.non_explr_win = vim.api.nvim_get_current_win()
  local cwDir = vim.fn.getcwd()

  -- Get all files and directories in CWD
  local cwdContent = vim.split(vim.fn.glob(cwDir .. '/*'), '\n', { trimempty = true })
  for i, d in ipairs(cwdContent) do
    cwdContent[i] = d:gsub(cwDir .. '\\', '') .. (d:find('.', -5, true) == nil and '\\' or '')
  end
  -- cwdContent = vim.split(vim.fn.glob('C:\\Users\\irawi\\AppData\\Local\\nvim\\lua' .. '/*'), '\n', { trimempty = true })
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, cwdContent)
  if not vim.api.nvim_win_is_valid(vim.g.explorer_win) then
    vim.cmd 'topleft vs'
    vim.cmd 'vertical resize 30'
    vim.cmd 'set nonu'
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
    vim.g.explorer_win = win
  elseif vim.api.nvim_win_get_buf(vim.g.explorer_win) ~= buf then
    vim.api.nvim_win_set_buf(vim.g.explorer_win, buf)
  end
end

function BetterExplorerSelect()
  local cursor_row = vim.api.nvim_win_get_cursor(vim.g.explorer_win)[1] - 1
  local row_content = vim.api.nvim_buf_get_lines(vim.g.explorer_buf, cursor_row, cursor_row + 1, true)[1]
  if row_content:find('.', -5, true) ~= nil then
    vim.api.nvim_set_current_win(vim.g.non_explr_win)
    vim.cmd('e ' .. row_content)
  else
    BetterExplorerOpen(cursor_row)
  end
end

function BetterExplorerOpen(idx)
  local cwDir = vim.fn.getcwd() .. '\\' .. vim.api.nvim_buf_get_lines(vim.g.explorer_buf, idx, idx + 1, true)[1]
  local cwdContent = vim.split(vim.fn.glob(cwDir .. '/*'), '\n', { trimempty = true })
  for i, d in ipairs(cwdContent) do
    local formatted = '  ' .. d:gsub(cwDir .. '\\', '') .. (d:find('.', -5, true) == nil and '\\' or '')

    vim.api.nvim_buf_set_lines(vim.g.explorer_buf, idx + i, idx + i, true, { formatted })
    -- cwdContent[i]=d:gsub(cwDir, "")
  end
  -- vim.api.nvim_buf_set_lines(buf, 0, -1, true, cwdContent)
end
