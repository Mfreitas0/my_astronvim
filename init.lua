-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

require "lazy_setup"
require "polish"

------ CONFIG TREE

require("neo-tree").setup {
  filesystem = {
    follow_current_file = true,
    use_libuv_file_watcher = true,
    hijack_netrw_behavior = "open_default",
    window = {
      position = "left",
      width = 30,
      mappings = {
        ["s"] = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" then
            state.commands.toggle_directory(state)
          else
            -- Use 'edit' para abrir o arquivo no buffer atual
            vim.api.nvim_command("edit " .. node.path)
          end
        end,
      },
    },
  },
  buffers = {
    follow_current_file = true,
    window = {
      position = "left",
      width = 30,
      mappings = {
        ["s"] = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" then
            state.commands.toggle_directory(state)
          else
            -- Use 'edit' para abrir o buffer no buffer atual
            vim.api.nvim_command("edit " .. node.path)
          end
        end,
      },
    },
  },
}

-- Mapeamento de Teclas para abrir o neo-tree
vim.api.nvim_set_keymap("n", "<F3>", ":Neotree toggle<CR>", { noremap = true, silent = true })

-- Mapeamento de teclas para navegar entre buffers abertos
vim.api.nvim_set_keymap("n", "<S-h>", ":bnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-l>", ":bprevious<CR>", { noremap = true, silent = true })

--------------------------------------------------------------------------------------------
--##############################CONFIURACOES DO TERMINAL###################################
--
require("toggleterm").setup {
  size = 15,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = "1",
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
  persist_size = true,
  direction = "horizontal", -- Define o modo horizontal split
  close_on_exit = true,
  shell = vim.o.shell,
}

vim.api.nvim_set_keymap("n", "<F2>", ":ToggleTerm direction=horizontal<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("t", "<F2>", [[<C-\><C-n><Cmd>ToggleTerm<CR>]], { noremap = true, silent = true })
--
--
--
-- cnfigurando rolangem dentro do terminal
-- Função para rolar o terminal
-- Função para rolar o terminal
function _G.set_terminal_keymaps()
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(0, "t", "<PageUp>", [[<C-\><C-n><C-b>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<PageDown>", [[<C-\><C-n><C-f>]], opts)
end

-- Configuração do autocomando para definir as teclas no terminal
vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"
-------------------------------------------------------------------------
--
---------------------------------------------------------------------------
----QUEBRA DE LINHA
-- Mapeamento de tecla para alternar a quebra de linha com F4
vim.api.nvim_set_keymap("n", "<F4>", ":set wrap!<CR>", { noremap = true, silent = true })

-----------------------------------------------------------------------
--EXECUTAR ARQUIVO ATUAAL
-- Função para executar o arquivo atual no toggleterm
-- Função para executar o arquivo atual no terminal toggleterm
local function execute_file_in_toggleterm()
  local file = vim.fn.expand "%"
  local cmd = "python3 " .. file

  -- Abre ou foca o terminal na orientação horizontal
  vim.cmd "ToggleTerm direction=horizontal"

  -- Aguarda um momento para garantir que o terminal esteja pronto
  vim.defer_fn(function()
    -- Envia o comando para o terminal
    vim.api.nvim_chan_send(vim.b.terminal_job_id, cmd .. "\n")
  end, 100)
end

-- Torna a função globalmente acessível
_G.execute_file_in_toggleterm = execute_file_in_toggleterm

-- Mapear a tecla para executar o arquivo Python atual
vim.api.nvim_set_keymap("n", "<F5>", ":lua execute_file_in_toggleterm()<CR>", { noremap = true, silent = true })

------------------------------------------------------------------------------------------
--DESTACAR LINHA ATUAL

-- Definir esquema de cores personalizado para a numeração de linhas
vim.cmd [[
  highlight LineNr guifg=#FFFFFF
  highlight CursorLineNr guifg=#FFA500
]]

-- Configurar numeração de linhas
vim.o.number = true -- Habilitar números de linha
vim.o.relativenumber = false -- Desativar números de linha relativos
vim.wo.cursorline = true -- Ativar destaque da linha atual

---------------------------------------------------------------
--INDETAÇÃO COM TAB & SHIFT+TAB
-- Função para configurar mapeamentos de teclas
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Mapeamentos para indentar e remover indentação
-- Indentar linha(s) selecionada(s) em modo normal e visual
map("n", "<Tab>", ">>")
map("v", "<Tab>", ">gv")

-- Remover indentação de linha(s) selecionada(s) em modo normal e visual
map("n", "<S-Tab>", "<<")
map("v", "<S-Tab>", "<gv")

--#####################################################################################
-- nvim-cmp configuration
local cmp = require "cmp"

cmp.setup {
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-e>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    ["<CR>"] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require("luasnip").expand_or_jumpable() then
        require("luasnip").expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require("luasnip").jumpable(-1) then
        require("luasnip").jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = cmp.config.sources {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
}

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})
