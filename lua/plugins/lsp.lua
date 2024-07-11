local lspconfig = require "lspconfig"

local function get_python_path(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then return vim.env.VIRTUAL_ENV .. "/bin/python" end

  -- Find and use virtualenv in workspace directory.
  local match = vim.fn.glob(workspace .. "/.venv")
  if match ~= "" then return match .. "/bin/python" end

  return "python"
end

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

-- Configurações do Pylsp
lspconfig.pylsp.setup {
  settings = {
    pylsp = {
      plugins = {
        pylint = { enabled = false },
        pyflakes = { enabled = false },
        pycodestyle = { enabled = false },
        mccabe = { enabled = false },
        pydocstyle = { enabled = false },
      },
    },
  },
  on_new_config = function(new_config, new_root_dir)
    new_config.settings.pylsp.plugins.pylsp_mypy.venvPath = get_python_path(new_root_dir)
  end,
}

return {}
