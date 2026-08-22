return {
  -- Visual undo history (branching undo is invisible without it)
  {
    "mbbill/undotree",
    cmd = { "UndotreeToggle" },
    keys = {
      { "<leader>U", "<cmd>UndotreeToggle<cr>", desc = "Undotree" },
    },
  },
}
