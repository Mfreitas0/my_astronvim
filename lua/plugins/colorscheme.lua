return {
  {
    "Mofiqul/dracula.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("dracula").setup {
        -- Use transparent background
        transparent_bg = true,
        -- Show the end-of-buffer '~' characters
        show_end_of_buffer = true,
        -- Use italic for comments
        italic_comment = true,
        -- Custom colors
        colors = {
          bg = "#1E1E2E",
          fg = "#F8F8F2",
          selection = "#44475A",
          comment = "#6272A4",
          red = "#FF5555",
          orange = "#FFB86C",
          yellow = "#F1FA8C",
          green = "#50FA7B",
          purple = "#BD93F9",
          cyan = "#8BE9FD",
          pink = "#FF79C6",
          bright_red = "#FF6E6E",
          bright_green = "#69FF94",
          bright_yellow = "#FFFFA5",
          bright_blue = "#D6ACFF",
          bright_magenta = "#FF92DF",
          bright_cyan = "#A4FFFF",
          bright_white = "#FFFFFF",
          menu = "#21222C",
          visual = "#3E4452",
          gutter_fg = "#4B5263",
          nontext = "#3B4048",
        },
        -- Custom highlights
        highlights = {
          Comment = { fg = "#6272A4", italic = true },
          CursorLineNr = { fg = "#FF79C6" },
          LineNr = { fg = "#6272A4" },
          Normal = { bg = "1E1E2E" },
          Visual = { bg = "#44475A" },
        },
      }
      -- load the colorscheme here
      vim.cmd [[colorscheme dracula]]
    end,
  },
}

-- return {
--   {
--     "sainnhe/gruvbox-material",
--     priority = 1000, -- make sure to load this before all the other start plugins
--     config = function()
--       vim.g.gruvbox_material_background = "soft"
--       vim.g.gruvbox_material_palette = "material"
--       vim.g.gruvbox_material_enable_bold = 1
--       vim.g.gruvbox_material_enable_italic = 1
--
--       -- Customizing the colors
--       local colors = {
--         bg = "#fbf1c7",
--         fg = "#3c3836",
--         red = "#cc241d",
--         green = "#98971a",
--         yellow = "#d79921",
--         blue = "#458588",
--         purple = "#b16286",
--         aqua = "#689d6a",
--         orange = "#d65d0e",
--       }
--
--       -- Applying the custom colors
--       vim.cmd("highlight Normal guibg=" .. colors.bg)
--       vim.cmd("highlight Normal guifg=" .. colors.fg)
--       vim.cmd("highlight Comment guifg=" .. colors.green)
--       vim.cmd("highlight Identifier guifg=" .. colors.blue)
--       vim.cmd("highlight Statement guifg=" .. colors.red)
--       vim.cmd("highlight PreProc guifg=" .. colors.orange)
--       vim.cmd("highlight Type guifg=" .. colors.purple)
--       vim.cmd("highlight Special guifg=" .. colors.aqua)
--       vim.cmd("highlight Underlined guifg=" .. colors.blue .. " gui=underline")
--
--       -- load the colorscheme here
--       vim.cmd [[colorscheme gruvbox-material]]
--     end,
--   },
-- }
--
-- return {
--   {
--     "folke/tokyonight.nvim",
--     priority = 1000, -- make sure to load this before all the other start plugins
--     config = function()
--       local bg = "#1d1b38"
--       local bg_dark = "#1d1b38"
--       local bg_highlight = "#143652"
--       local bg_search = "#8f2171"
--       local bg_visual = "#275378"
--       local fg = "#CBE0F0"
--       local fg_dark = "#B4D0E9"
--       local fg_gutter = "#627E97"
--       local border = "#547998"
--
--       require("tokyonight").setup {
--         style = "night",
--         on_colors = function(colors)
--           colors.bg = bg
--           colors.bg_dark = bg_dark
--           colors.bg_float = bg_dark
--           colors.bg_highlight = bg_highlight
--           colors.bg_popup = bg_dark
--           colors.bg_search = bg_search
--           colors.bg_sidebar = bg_dark
--           colors.bg_statusline = bg_dark
--           colors.bg_visual = bg_visual
--           colors.border = border
--           colors.fg = fg
--           colors.fg_dark = fg_dark
--           colors.fg_float = fg
--           colors.fg_gutter = fg_gutter
--           colors.fg_sidebar = fg_dark
--         end,
--       }
--       -- load the colorscheme here
--       vim.cmd [[colorscheme tokyonight]]
--     end,
--   },
-- }
--
