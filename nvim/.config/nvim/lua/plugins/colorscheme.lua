-- Night Owl: matches the Ghostty / herdr terminal theme (#00111E background)
return {
  {
    "oxfist/night-owl.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "night-owl",
    },
  },
}
