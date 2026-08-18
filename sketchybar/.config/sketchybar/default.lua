local colors = require("colors")

sbar.default({
  padding_left = 5,
  padding_right = 5,
  icon = {
    font = { family = "FiraCode Nerd Font", style = "Bold", size = 15.0 },
    color = colors.white,
    padding_left = 4,
    padding_right = 4,
  },
  label = {
    font = { family = "FiraCode Nerd Font", style = "Medium", size = 13.0 },
    color = colors.white,
    padding_left = 4,
    padding_right = 4,
  },
  popup = {
    background = {
      color = colors.popup.bg,
      border_color = colors.popup.border,
      border_width = 1,
      corner_radius = 6,
    },
  },
})
