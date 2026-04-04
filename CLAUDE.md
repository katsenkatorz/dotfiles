# Dotfiles — Instructions pour Claude Code

## Projet

Repo dotfiles macOS géré avec GNU Stow. Config : Ghostty + Fish + tmux + LazyVim.

## Structure

```
~/dotfiles/
├── install.sh              # Script idempotent (brew, stow, tpm, lazyvim starter)
├── tmux/.tmux.conf         # Prefix Ctrl-a, popups persistants, Tokyo Night
├── nvim/.config/nvim/lua/
│   ├── config/options.lua  # Options custom (relativenumber, scrolloff, wrap)
│   └── plugins/
│       ├── extras.lua      # Extras LazyVim (PHP, TS, Tailwind, Docker, YAML, Markdown)
│       ├── tmux-navigator.lua  # Navigation Ctrl-h/j/k/l entre tmux et nvim
│       └── ui.lua          # Thème gruvbox, lualine, mini-starter (existant)
├── fish/.config/fish/conf.d/
│   └── tmux.fish           # Auto-start tmux dans Ghostty
└── ghostty/.config/ghostty/
    └── config              # Font JetBrainsMono Nerd Font, taille 14
```

## Convention Stow

Chaque dossier racine (`tmux/`, `nvim/`, `fish/`, `ghostty/`) reproduit l'arborescence depuis `$HOME`. `stow <module>` crée les symlinks.

Pour nvim : on ne versionne que les customisations. Le starter LazyVim est cloné par `install.sh` (pas dans le repo). Stow avec `--adopt` fusionne nos fichiers par-dessus.

## Règles

- **Ne pas versionner** : `init.lua`, `lazy-lock.json`, `lazyvim.json` et les fichiers du starter LazyVim
- **Ajouter un nouveau module** : créer `<module>/.config/<module>/...` dans le repo, ajouter le `stow` dans install.sh
- **install.sh doit rester idempotent** : vérifier avant d'agir, backup avant d'écraser, ne jamais écraser silencieusement
- **macOS uniquement** : utiliser `gmd5sum` (coreutils) au lieu de `md5sum`
- **Popups tmux** : `Ctrl-a` + lettre, session persistante pour Claude Code (hash du chemin)

## Bindings tmux importants

| Binding | Action |
|---|---|
| `Ctrl-a y` | Claude Code popup (persistant/projet) |
| `Ctrl-a g` | LazyGit popup |
| `Ctrl-a d` | LazyDocker popup |
| `Ctrl-a e` | Neovim popup |
| `Ctrl-a b` | bottom popup |
| `Ctrl-a v/s` | Split vertical/horizontal |
| `Ctrl-a c` | Nouvelle fenêtre |
| `Ctrl-a r` | Reload config |

## Dépendances brew

tmux neovim lazygit lazydocker ripgrep fd fzf node coreutils bottom stow gh

Cask : font-jetbrains-mono-nerd-font

## Plugins tmux (TPM)

tmux-sensible, tmux-resurrect, tmux-continuum, tmux-yank, vim-tmux-navigator
