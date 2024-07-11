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
--

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

--############################################################################################
--PADRAO DO CursorLine
-- Define estilos diferentes para o cursor
vim.opt.guicursor = "n-v-c-sm-ve:ver25,i-ci:ver25,r-cr-o:hor20,a:blinkon0"

-- Alternar o estilo e a cor do cursor entre normal e outros modos
--###################################################################################
vim.cmd [[
  augroup CursorStyles
    autocmd!
    autocmd InsertEnter * highlight Cursor guifg=NONE guibg=#ff00ff
    autocmd InsertLeave * highlight Cursor guifg=NONE guibg=NONE
    autocmd InsertEnter * set guicursor+=i-ci:hor20
    autocmd InsertLeave * set guicursor=n-v-c-sm-ve:ver25,i-ci:hor20,r-cr-o:hor20
    autocmd ModeChanged *:[vV\x16]* highlight Cursor guifg=NONE guibg=#ff00ff
    autocmd ModeChanged *:[vV\x16]* set guicursor+=v:hor20
    autocmd ModeChanged [vV\x16]*:* highlight Cursor guifg=NONE guibg=NONE
    autocmd ModeChanged [vV\x16]*:* set guicursor=n-v-c-sm-ve:ver25,i-ci:hor20,r-cr-o:hor20
  augroup END
]]
--pyrigth com o checking off
require("lspconfig").pyright.setup {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",
        diagnosticMode = "workspace",
      },
    },
  },
}

--############################################################################################
--MOVER LINHA COM ALT
-- Função para mover uma linha ou linhas selecionadas para cima
-- Função para mover uma linha ou linhas selecionadas para cima
_G.move_line_up = function()
  local mode = vim.api.nvim_get_mode().mode
  if mode == "v" or mode == "V" or mode == "<C-v>" then
    vim.cmd "'<,'>move '<-2"
    vim.cmd "normal! gv"
  else
    vim.cmd "move .-2"
  end
end

-- Função para mover uma linha ou linhas selecionadas para baixo
_G.move_line_down = function()
  local mode = vim.api.nvim_get_mode().mode
  if mode == "v" or mode == "V" or mode == "<C-v>" then
    vim.cmd "'<,'>move '>+1"
    vim.cmd "normal! gv"
  else
    vim.cmd "move .+1"
  end
end

-- Mapear Alt+K para mover a linha ou seleção para cima
vim.api.nvim_set_keymap("n", "<A-k>", ":lua move_line_up()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<A-k>", ":lua move_line_up()<CR>", { noremap = true, silent = true })

-- Mapear Alt+J para mover a linha ou seleção para baixo
vim.api.nvim_set_keymap("n", "<A-j>", ":lua move_line_down()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<A-j>", ":lua move_line_down()<CR>", { noremap = true, silent = true })
--#################################################################################################
--
--ADICIONAR PARES NO MODO VISUAL
-- Mapear para envolver seleção com parênteses
vim.api.nvim_set_keymap("x", "<leader>(", "<Esc>`>a)<Esc>`<i(<Esc>", { noremap = true, silent = true })

-- Mapear para envolver seleção com colchetes
vim.api.nvim_set_keymap("x", "<leader>[", "<Esc>`>a]<Esc>`<i[<Esc>", { noremap = true, silent = true })

-- Mapear para envolver seleção com aspas duplas
vim.api.nvim_set_keymap("x", '<leader>"', '<Esc>`>a"<Esc>`<i"<Esc>', { noremap = true, silent = true })

-- Mapear para envolver seleção com aspas simples
vim.api.nvim_set_keymap("x", "<leader>'", "<Esc>`>a'<Esc>`<i'<Esc>", { noremap = true, silent = true })

-- Mapear para envolver seleção com chaves
vim.api.nvim_set_keymap("x", "<leader>{", "<Esc>`>a}<Esc>`<i{<Esc>", { noremap = true, silent = true })

--########################################################################################
--DROBRAMENTO DE SINTAXE DE CODIGO
--za:Alterna o fold sob o cursor (abre se estiver fechado e fecha se estiver aberto).
-- zc: Fecha o fold sob o cursor.
-- zo: Abre o fold sob o cursor.
-- zR: Abre todos os folds no buffer.
-- zM: Fecha todos os folds no buffer.
--
-- ##################################################################################
--
-- No seu arquivo de configuração do Neovim (ex: init.lua)
require("lspconfig").pyright.setup {
  on_attach = function(client, bufnr)
    -- Outros setups, se necessário
  end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace", -- ou "openFilesOnly" se você quiser limitar a análise
        typeCheckingMode = "off", -- Desativa o type checking rigoroso
      },
    },
  },
}

--
--#########################################################
--AMBIENTE VIRTUAL
-- Outras configurações do seu init.lua

-- Função para ativar ambiente virtual
local function activate_virtualenv()
  if os.getenv "VIRTUAL_ENV" then return end

  local handle = io.popen "poetry env info --path 2>/dev/null"
  local poetry_venv = handle:read "*a"
  handle:close()

  if poetry_venv and poetry_venv ~= "" then
    poetry_venv = poetry_venv:gsub("%s+", "")
    vim.env.VIRTUAL_ENV = poetry_venv
    vim.env.PATH = poetry_venv .. "/bin:" .. vim.env.PATH
    print("Activated Poetry virtualenv: " .. poetry_venv)
    return
  end

  local venv_dir = vim.fn.finddir("venv", ".;")
  if venv_dir ~= "" then
    local venv_path = vim.fn.resolve(venv_dir)
    vim.env.VIRTUAL_ENV = venv_path
    vim.env.PATH = venv_path .. "/bin:" .. vim.env.PATH
    print("Activated virtualenv: " .. venv_path)
  end
end

-- Executa a função ao iniciar o Neovim
activate_virtualenv()
