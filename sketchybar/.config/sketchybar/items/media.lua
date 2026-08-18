local colors = require("colors")

-- Now Playing via media-control: macOS 15.4+ closed the MediaRemote API,
-- the native media_change event no longer fires.
local MC = "/opt/homebrew/bin/media-control"

local media = sbar.add("item", "media", {
  position = "center",
  drawing = false,
  update_freq = 5,
  icon = { string = "󰝚", color = colors.red },
  label = { max_chars = 40 },
  scroll_texts = true,
})

local function refresh()
  sbar.exec(MC .. " get", function(info)
    if type(info) == "table" and info.title and info.title ~= "" then
      local label = info.title
      if info.artist and info.artist ~= "" then
        label = info.artist .. " · " .. info.title
      end
      media:set({
        drawing = true,
        icon = { string = info.playing and "󰐊" or "󰏤" },
        label = { string = label },
      })
    else
      media:set({ drawing = false })
    end
  end)
end

media:subscribe({ "routine", "forced" }, refresh)

media:subscribe("mouse.clicked", function()
  sbar.exec(MC .. " toggle-play-pause && sleep 0.3", refresh)
end)
