local colors = require("colors")

----- Volume: click = slider popup, right click = mute, scroll = adjust -----

local volume = sbar.add("item", "volume", {
  position = "right",
  popup = { horizontal = true },
})

local volume_slider = sbar.add("slider", 120, {
  position = "popup." .. volume.name,
  slider = {
    highlight_color = colors.blue,
    background = {
      height = 6,
      corner_radius = 3,
      color = colors.bg2,
    },
    knob = { string = "󰝥", color = colors.white },
  },
})

volume_slider:subscribe("mouse.clicked", function(env)
  sbar.exec("osascript -e 'set volume output volume " .. env.PERCENTAGE .. "'")
end)

volume:subscribe("volume_change", function(env)
  local vol = tonumber(env.INFO) or 0
  local icon = "󰖁"
  if vol >= 60 then icon = "󰕾"
  elseif vol >= 30 then icon = "󰖀"
  elseif vol >= 1 then icon = "󰕿" end
  volume:set({ icon = { string = icon }, label = vol .. "%" })
  volume_slider:set({ slider = { percentage = vol } })
end)

volume:subscribe("mouse.clicked", function(env)
  if env.BUTTON == "right" then
    sbar.exec("osascript -e 'set volume output muted (not output muted of (get volume settings))'")
  else
    volume:set({ popup = { drawing = "toggle" } })
  end
end)

volume:subscribe("mouse.scrolled", function(env)
  sbar.exec("osascript -e 'set volume output volume ((output volume of (get volume settings)) + "
    .. (env.SCROLL_DELTA or 0) .. ")'")
end)

volume:subscribe("mouse.exited.global", function()
  volume:set({ popup = { drawing = false } })
end)

----- Battery -----

local battery = sbar.add("item", "battery", {
  position = "right",
  update_freq = 120,
})

battery:subscribe({ "routine", "forced", "system_woke", "power_source_change" }, function()
  sbar.exec("pmset -g batt", function(info)
    local pct = tostring(info):match("(%d+)%%")
    if not pct then
      battery:set({ drawing = false })
      return
    end
    local n = tonumber(pct)
    local icon, color = "󰁺", colors.red
    if tostring(info):find("AC Power") then icon, color = "󰂄", colors.green
    elseif n >= 90 then icon, color = "󰁹", colors.green
    elseif n >= 60 then icon, color = "󰂀", colors.yellow
    elseif n >= 30 then icon, color = "󰁾", colors.orange
    elseif n >= 10 then icon, color = "󰁻", colors.orange end
    battery:set({ drawing = true, icon = { string = icon, color = color }, label = pct .. "%" })
  end)
end)

battery:subscribe("mouse.clicked", function()
  sbar.exec("open x-apple.systempreferences:com.apple.Battery-Settings.extension")
end)

----- Wi-Fi: SSID via system_profiler (ipconfig returns <redacted> without -----
----- location permission), click = popup with local IP and settings link -----

local wifi = sbar.add("item", "wifi", {
  position = "right",
  update_freq = 60,
})

local wifi_ip = sbar.add("item", "wifi.ip", {
  position = "popup." .. wifi.name,
  icon = { string = "󰩟", color = colors.blue },
})

local wifi_settings = sbar.add("item", "wifi.settings", {
  position = "popup." .. wifi.name,
  icon = { string = "󰒓" },
  label = "Réglages Wi-Fi...",
})

wifi_settings:subscribe("mouse.clicked", function()
  sbar.exec("open x-apple.systempreferences:com.apple.wifi-settings-extension")
  wifi:set({ popup = { drawing = false } })
end)

wifi:subscribe({ "routine", "forced", "wifi_change", "system_woke" }, function()
  sbar.exec([[system_profiler SPAirPortDataType 2>/dev/null | awk '/Current Network Information:/{getline; line=$0; sub(/^ */,"",line); sub(/:$/,"",line); print line; exit}']], function(ssid)
    ssid = tostring(ssid or ""):gsub("%s+$", "")
    if ssid ~= "" then
      wifi:set({ icon = { string = "󰤨" }, label = ssid })
    else
      wifi:set({ icon = { string = "󰤭" }, label = "off" })
    end
  end)
end)

wifi:subscribe("mouse.clicked", function()
  sbar.exec("ipconfig getifaddr en0", function(ip)
    ip = tostring(ip or ""):gsub("%s+$", "")
    if ip == "" then ip = "aucune" end
    wifi_ip:set({ label = "IP  " .. ip })
    wifi:set({ popup = { drawing = "toggle" } })
  end)
end)

wifi:subscribe("mouse.exited.global", function()
  wifi:set({ popup = { drawing = false } })
end)

----- Weather (wttr.in, no API key), click = Weather app -----

local weather = sbar.add("item", "weather", {
  position = "right",
  update_freq = 1800,
  icon = { drawing = false },
})

weather:subscribe({ "routine", "forced", "system_woke" }, function()
  -- City pinned: IP geolocation resolves the ISP exit (Paris), not home.
  sbar.exec([[curl -s --max-time 10 'https://wttr.in/Angers?format=%c%t' | tr -d '+']], function(out)
    out = tostring(out or ""):gsub("%s+$", "")
    if out ~= "" and not out:find("Unknown") and not out:find("Sorry") then
      weather:set({ drawing = true, label = out })
    end
  end)
end)

weather:subscribe("mouse.clicked", function()
  sbar.exec("open -a Weather")
end)

----- RAM + CPU -----

local ram = sbar.add("item", "ram", {
  position = "right",
  update_freq = 10,
  icon = { string = "󰍛" },
})

ram:subscribe({ "routine", "forced" }, function()
  sbar.exec([[memory_pressure | awk '/percentage/ {gsub("%","",$NF); printf "%d%%", 100-$NF}']], function(out)
    ram:set({ label = tostring(out) })
  end)
end)

local cpu = sbar.add("item", "cpu", {
  position = "right",
  update_freq = 5,
  icon = { string = "󰘚" },
})

-- Two top samples: the first one only reports the since-boot average.
cpu:subscribe({ "routine", "forced" }, function()
  sbar.exec([[top -l 2 -n 0 -s 1 | awk '/CPU usage/ {u=$3; s=$5} END {gsub("%","",u); gsub("%","",s); printf "%d%%", u+s}']], function(out)
    cpu:set({ label = tostring(out) })
  end)
end)
