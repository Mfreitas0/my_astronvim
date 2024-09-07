-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo(
    { { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } },
    true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

require "lazy_setup"
require "polish"

-- -- > Config Neotree <-- -------------------------------------------------
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
            vim.api.nvim_command("edit " .. node.path)
          end
        end,
      },
    },
  },
}

-- Mapeamento de Teclas para abrir o neo-tree
vim.api.nvim_set_keymap("n", "<F3>", ":Neotree toggle<CR>", { noremap = true, silent = true })

--
--
--
---------> CONFIURACOES DO TERMINAL <----------------------------------------------

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
  close_on_exit = false, -- Garanta que o terminal não feche após a execução do comando
  shell = vim.o.shell,
  float_opts = {
    border = "curved", -- Tipo de borda para o terminal flutuante "curved"
    width = 84,
    height = 35,
    winblend = 4,
  },
}

local Terminal = require("toggleterm.terminal").Terminal

local horizontal_term = Terminal:new { direction = "horizontal", hidden = true, close_on_exit = true }

function _G.run_current_file()
  local file = vim.fn.expand "%:p"
  local ext = vim.fn.expand "%:e"
  local cmd = ""

  if ext == "py" then
    cmd = "python " .. file
  elseif ext == "lua" then
    cmd = "lua " .. file
  elseif ext == "js" then
    cmd = "node " .. file
  else
    vim.notify(" Não Foi Encontrado Suporte Para Esta Extensão: " .. ext, vim.log.levels.WARN)
    return
  end

  horizontal_term:toggle()
  vim.defer_fn(function()
    horizontal_term:send(cmd .. "\n", true)
    vim.notify("▶ Executando arquivo: " .. file, vim.log.levels.INFO)
  end, 100)
end

-- Mapeamento de tecla para abrir o terminal flutuante
vim.api.nvim_set_keymap("n", "<C-\\>", ":ToggleTerm direction=float<CR>", { noremap = true, silent = true })

-- Mapeamento de tecla para executar o arquivo atual no terminal horizontal
vim.api.nvim_set_keymap("n", "<F6>", ":lua run_current_file()<CR>", { noremap = true, silent = true })

---------------> Função para rolar o terminal <--------------------------------
function _G.set_terminal_keymaps()
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(0, "t", "<Home>", [[<C-\><C-n><C-b>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<End>", [[<C-\><C-n><C-f>]], opts)
end

vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"

-- -- > QUEBRA DE LINHA < -- ----------------------------------------------
vim.api.nvim_set_keymap("n", "<F4>", ":set wrap!<CR>", { noremap = true, silent = true })

-- -- > DESTACAR LINHA ATUAL < -- -----------------------------------------

vim.cmd [[
  highlight LineNr guifg=#FFFFFF
  highlight CursorLineNr guifg=#FFA500
]]

-- Configurar numeração de linhas
vim.o.number = true -- Habilitar números de linha
vim.o.relativenumber = false -- Desativar números de linha relativos
vim.wo.cursorline = true -- Ativar destaque da linha atual

-- -- > INDETAÇÃO COM TAB & SHIFT+TAB < -- -----------------------------------
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("n", "<Tab>", ">>")
map("v", "<Tab>", ">gv")

map("n", "<S-Tab>", "<<")
map("v", "<S-Tab>", "<gv")

--
--
--
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

-- -- Use cmdline & path source for ':' (if you enabled `native_menu

-- -- > cor notify < -- -----------------------------------------------

require("notify").setup {
  background_colour = "#000000",
  stages = "fade",
  timeout = 3000,
  max_width = 50,
  max_height = 10,
  on_open = nil,
  on_close = nil,
  render = "default",
  minimum_width = 50,
  icons = {
    ERROR = "",
    WARN = "",
    INFO = "",
    DEBUG = "",
    TRACE = "✎",
  },
  level = "info", -- nível de prioridade (pode ser "trace", "debug", "info", "warn", "error", "off")
  top_down = true,
  fps = 30,
  stages = "fade_in_slide_out",
}

--
--
--
-- -- > Padrao do CursorLine < -- -----------------------------------
-- Define estilos diferentes para o cursor
vim.opt.guicursor = "n-v-c-sm-ve:ver25,i-ci:ver25,r-cr-o:hor20,a:blinkon0"

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
--
--
--
-- -- >Move linha com ALT < -- -- ----------------------------
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

-- mapear alt+j para mover a linha ou seleção para baixo
vim.api.nvim_set_keymap("n", "<a-j>", ":lua move_line_down()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<a-j>", ":lua move_line_down()<cr>", { noremap = true, silent = true })
--
--
-- -- > Pares (){}[] "" ''< -- --

-- Mapear para envolver seleção com parênteses
vim.api.nvim_set_keymap("x", "<leader>(", 'c(<C-r>")<Esc>', { noremap = true, silent = true })

-- Mapear para envolver seleção com colchetes
vim.api.nvim_set_keymap("x", "<leader>[", 'c[<C-r>"]<Esc>', { noremap = true, silent = true })

-- Mapear para envolver seleção com chaves
vim.api.nvim_set_keymap("x", "<leader>{", 'c{<C-r>"}<Esc>', { noremap = true, silent = true })

-- Mapear para envolver seleção com aspas duplas
vim.api.nvim_set_keymap("x", '<leader>"', 'c"<C-r>""<Esc>', { noremap = true, silent = true })

-- Mapear para envolver seleção com aspas simples
vim.api.nvim_set_keymap("x", "<leader>'", "c'<C-r>\"'<Esc>", { noremap = true, silent = true })

--
--
--
-- -- > pyright erros < -- --
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
--
--
--
-- -- > AMBIENTE VIRTUAL < -- --

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
    vim.notify("Activated Poetry virtualenv: " .. poetry_venv)
    return
  end

  local venv_dir = vim.fn.finddir("venv", ".;")
  if venv_dir ~= "" then
    local venv_path = vim.fn.resolve(venv_dir)
    vim.env.VIRTUAL_ENV = venv_path
    vim.env.PATH = venv_path .. "/bin:" .. vim.env.PATH
    vim.notify("Activated virtualenv: " .. venv_path)
  end
end

-- Executa a função ao iniciar o Neovim
activate_virtualenv()
--
--
-- -- > Mapeamento de teclas para navegar entre buffers abertos < -- --
vim.api.nvim_set_keymap("n", "<S-l>", ":bnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-h>", ":bprevious<CR>", { noremap = true, silent = true })
--
--
--
