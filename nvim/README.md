# nvim : LazyVim

Config LazyVim complète, versionnée ici et symlinkée par Stow vers
`~/.config/nvim` (plus de clone du starter : le repo EST la config).

- Apprentissage et référence : [TUTO.md](TUTO.md)
- Extras gérés dans `lazyvim.json` (`:LazyExtras`)
- Plugins lockés dans `lazy-lock.json` : committer après chaque `:Lazy sync`
- Thème night-owl, aligné sur Ghostty / herdr (#011627)
- LSP : vtsls, biome, tailwindcss, phpactor, lua-ls... installés par Mason
  au premier lancement (`:Mason` pour la liste)

## Structure

```
.config/nvim/
├── init.lua                 # bootstrap
├── lazyvim.json             # extras actifs
├── lazy-lock.json           # lock des plugins
└── lua/
    ├── config/              # options, keymaps, autocmds, lazy bootstrap
    └── plugins/             # colorscheme (night-owl), editor (undotree)
```

Piège : le CLI `tree-sitter` requis par nvim-treesitter (branche main) est
un symlink `/opt/homebrew/bin/tree-sitter` vers le binaire Mason.
