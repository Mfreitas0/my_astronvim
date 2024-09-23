return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require "lualine"
    local lazy_status = require "lazy.status" -- to configure lazy pending updates count

    local colors = {
      blue = "#65D1FF",
      green = "#3EFFDC",
      violet = "#FF61EF",
      yellow = "#FFA500",
      red = "#FF4A4A",
      fg = "#c3ccdc",
      bg = "#112638",
      inactive_bg = "#2c3043",
      custom_bg = "#112638",
      gray = "#9370DB",
      git_bg = "#F5DEB3",
      error_bg = "#57354c",
    }

    local my_lualine_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
        b = { bg = colors.custom_bg, fg = colors.fg },
        c = { bg = colors.custom_bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.green, fg = colors.bg, gui = "bold" },
        b = { bg = colors.custom_bg, fg = colors.fg },
        c = { bg = colors.custom_bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
        b = { bg = colors.custom_bg, fg = colors.fg },
        c = { bg = colors.custom_bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
        b = { bg = colors.custom_bg, fg = colors.fg },
        c = { bg = colors.custom_bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = "bold" },
        b = { bg = colors.custom_bg, fg = colors.fg },
        c = { bg = colors.custom_bg, fg = colors.fg },
      },
      inactive = {
        a = { bg = colors.inactive_bg, fg = colors.fg, gui = "bold" },
        b = { bg = colors.inactive_bg, fg = colors.fg },
        c = { bg = colors.inactive_bg, fg = colors.fg },
      },
    }

    -- configure lualine with modified theme and separators
    lualine.setup {
      options = {
        theme = my_lualine_theme,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { { "mode", separator = { right = "" } } },
        lualine_b = {
          {
            "branch",
            icon = "",
            color = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
            separator = { right = "" },
          },
          {
            "diff",
            color = { bg = colors.git_bg, fg = colors.bg, gui = "bold" },
            symbols = { added = "● ", modified = "● ", removed = "● " },
            color_added = { fg = colors.green },
            color_modified = { fg = colors.blue },
            color_removed = { fg = colors.red },
            separator = { right = "" },
          },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            color = { bg = colors.error_bg, fg = colors.bg, gui = "bold" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
            diagnostics_color = {
              error = { fg = colors.red },
              warn = { fg = colors.yellow },
              info = { fg = colors.blue },
              hint = { fg = colors.violet },
            },
            separator = { right = "" },
          },
        },
        lualine_c = {
          {
            "filename",
            icon = "",
            color = { bg = colors.gray, fg = colors.bg, gui = "bold" },
            separator = { right = "" },
          },
        },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
            separator = { right = "" },
          },
          {
            "encoding",
            color = { bg = colors.gray, fg = colors.bg, gui = "bold" },
            separator = { left = "" },
          },
        },
        lualine_y = {
          {
            "filetype",
            color = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
            separator = { left = "" },
          },
        },
        lualine_z = { { "location", separator = { left = "" } } },
      },
      inactive_sections = {
        lualine_a = { { "mode", separator = { right = "" } } },
        lualine_b = { { "branch", separator = { right = "" } } },
        lualine_c = { { "filename", separator = { right = "" } } },
        lualine_x = { { "encoding", separator = { right = "" } } },
        lualine_y = { { "progress", separator = { right = "" } } },
        lualine_z = { { "location", separator = { right = "" } } },
      },
    }
  end,
}
