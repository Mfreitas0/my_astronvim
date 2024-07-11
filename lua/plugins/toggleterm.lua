local toggleterm = require "toggleterm"

toggleterm.setup {
  open_mapping = [[<c-\>]],
  shade_terminals = false,
  direction = "horizontal",
  size = 20,
}

-- Função para aplicar a cor de fundo personalizada ao terminal
local function set_terminal_background()
  vim.cmd "highlight ToggleTermBg guibg=#1e1e2e"
  vim.cmd "setlocal winhighlight=Normal:ToggleTermBg"
end

-- Aplica a cor de fundo personalizada ao abrir o terminal
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function() set_terminal_background() end,
})

return {}
