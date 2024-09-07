require("lazy").setup({
  -- Configurações dos plugins
  {
    "AstroNvim/AstroNvim",
    version = "^4", -- Remove version tracking to elect for nightly AstroNvim
    import = "astronvim.plugins",
    opts = { -- AstroNvim options must be set here with the import key
      mapleader = " ", -- Ensure the leader key is configured before Lazy is set up
      maplocalleader = ",", -- Ensure the localleader key is configured before Lazy is set up
      icons_enabled = true, -- Set to false to disable icons (if no Nerd Font is available)
      pin_plugins = nil, -- Pin plugins when tracking version of AstroNvim, set to true/false to override
      update_notifications = true, -- Enable/disable notifications about running :Lazy update twice to update pinned plugins
    },
  },
  { import = "community" },
  { import = "plugins" },

  {
    "vyfor/cord.nvim",
    build = "./build || .\\build",
    event = "VeryLazy",
    opts = {}, -- calls require('cord').setup()
  },
}, {
  -- Qualquer outra configuração de lazy.nvim
  install = { colorscheme = { "astrotheme", "habamax" } },
  ui = { backdrop = 100 },
  performance = {
    rtp = {
      -- Disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
      },
    },
  },
})

-- Adicionar o plugin presence.nvim
-- {
--   "andweeb/presence.nvim",
--   config = function()
--     require("presence"):setup {
--       -- General options
--       auto_update = true, -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
--       neovim_image_text = "The One True Text Editor", -- Text displayed when hovered over the Neovim image
--       main_image = "neovim", -- Main image display (either "neovim" or "file")
--       client_id = "793271441293967371", -- Use your own Discord application client id (not recommended)
--       log_level = nil, -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
--       debounce_timeout = 10, -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
--       enable_line_number = false, -- Displays the current line number instead of the current project
--       blacklist = {}, -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
--       buttons = true, -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
--       file_assets = {}, -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
--       show_time = true, -- Show the timer
--
--       -- Rich Presence text options
--       editing_text = "Editing %s", -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
--       file_explorer_text = "Browsing %s", -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
--       git_commit_text = "Committing changes", -- Format string rendered when committing changes in git (either string or function(filename: string): string)
--       plugin_manager_text = "Managing plugins", -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
--       reading_text = "Reading %s", -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
--       workspace_text = "Working on %s", -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
--       line_number_text = "Line %s out of %s", -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
--     }
--   end,
-- },
