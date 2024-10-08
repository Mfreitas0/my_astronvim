return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  config = function()
    require("bufferline").setup {
      options = {
        mode = "tabs", -- Modo tabs
        separator_style = "padded_slant",
        diagnostics = "nvim_lsp", -- ou "coc"
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        sort_by = "tabs", -- Ordenar por número de abas
      },
    }

    -- Mapeamento de teclas para navegar entre abas no bufferline
    vim.api.nvim_set_keymap("n", "<S-h>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<S-l>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })

    -- Mapeamento para organizar as abas por número
    vim.api.nvim_set_keymap("n", "<leader>bn", ":BufferLineSortByTabs<CR>", { noremap = true, silent = true })
  end,
}
