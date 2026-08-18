local colors = require("colors")
local icon_map = require("icon_map")

local spaces = {}

for i = 1, 10 do
  local space = sbar.add("space", "space." .. i, {
    space = i,
    icon = {
      string = tostring(i),
      color = colors.grey,
      highlight_color = colors.red,
      padding_left = 8,
      padding_right = 4,
    },
    label = {
      string = "",
      font = { family = "sketchybar-app-font", style = "Regular", size = 14.0 },
      color = colors.grey,
      highlight_color = colors.white,
      padding_right = 10,
      y_offset = -1,
    },
    background = {
      color = colors.bg1,
      corner_radius = 5,
      height = 24,
      drawing = false,
    },
  })
  spaces[i] = space

  space:subscribe("space_change", function(env)
    local selected = env.SELECTED == "true"
    space:set({
      icon = { highlight = selected },
      label = { highlight = selected },
      background = { drawing = selected },
    })
  end)

  -- Space focus needs the scripting addition; skhd synthesizes the native
  -- ctrl+N Mission Control shortcut as fallback.
  space:subscribe("mouse.clicked", function()
    sbar.exec("/opt/homebrew/bin/yabai -m space --focus " .. i
      .. " 2>/dev/null || /opt/homebrew/bin/skhd -k 'ctrl - " .. i .. "'")
  end)
end

-- space_windows_change delivers {space = n, apps = {name = count}}:
-- rebuild the app-icon strip of that space from the icon font map.
local observer = sbar.add("item", { drawing = false, updates = true })

observer:subscribe("space_windows_change", function(env)
  local icon_line = ""
  for app, _ in pairs(env.INFO.apps) do
    icon_line = icon_line .. (icon_map[app] or ":default:")
  end
  if icon_line == "" then icon_line = " " end

  sbar.animate("tanh", 10, function()
    spaces[env.INFO.space]:set({ label = icon_line })
  end)
end)
