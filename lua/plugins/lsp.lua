if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

local lspconfig = require "lspconfig"

-- Configurações do Pyright
lspconfig.pyright.setup {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",
        reportMissingImports = false,
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
  on_new_config = function(new_config, new_root_dir)
    new_config.settings.python.pythonPath = get_python_path(new_root_dir)
  end,
}

return {}
