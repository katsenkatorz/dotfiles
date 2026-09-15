-- Catppuccin Mocha: matches Ghostty, herdr and Starship (catppuccin plugin ships with LazyVim)
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
