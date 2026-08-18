local calendar = sbar.add("item", "calendar", {
  position = "right",
  update_freq = 10,
  icon = { string = "" },
})

calendar:subscribe({ "routine", "forced", "system_woke" }, function()
  calendar:set({ label = os.date("%d/%m %H:%M") })
end)

calendar:subscribe("mouse.clicked", function()
  sbar.exec("open -a Calendar")
end)
