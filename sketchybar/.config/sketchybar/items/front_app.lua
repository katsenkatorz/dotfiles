local colors = require("colors")
local icon_map = require("icon_map")

local front_app = sbar.add("item", "front_app", {
  icon = {
    font = { family = "sketchybar-app-font", style = "Regular", size = 14.0 },
    color = colors.accent,
  },
  label = {
    font = { style = "Bold" },
  },
})

front_app:subscribe("front_app_switched", function(env)
  front_app:set({
    icon = { string = icon_map[env.INFO] or ":default:" },
    label = { string = env.INFO },
  })
end)

front_app:subscribe("mouse.clicked", function()
  sbar.exec("/opt/homebrew/bin/yabai -m window --toggle zoom-fullscreen")
end)
