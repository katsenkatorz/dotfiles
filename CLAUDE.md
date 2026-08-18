# Dotfiles — Instructions pour Claude Code

## Projet

Repo dotfiles macOS géré avec GNU Stow. Config : Ghostty + Fish + LazyVim.

## Structure

```
~/dotfiles/
├── install.sh              # Script idempotent (brew, stow, lazyvim starter)
├── nvim/.config/nvim/lua/
│   ├── config/options.lua  # Options custom (relativenumber, scrolloff, wrap)
│   └── plugins/
│       ├── extras.lua      # Extras LazyVim (PHP, TS, Tailwind, Docker, YAML, Markdown)
│       └── ui.lua          # Thème gruvbox, lualine, mini-starter (existant)
├── fish/.config/fish/       # config.fish, conf.d/, fish_plugins
└── ghostty/.config/ghostty/
    └── config              # Font FiraCode Nerd Font, taille 14
```

## Convention Stow

Chaque dossier racine (`nvim/`, `fish/`, `ghostty/`, `starship/`) reproduit l'arborescence depuis `$HOME`. `stow <module>` crée les symlinks.

Pour nvim : on ne versionne que les customisations. Le starter LazyVim est cloné par `install.sh` (pas dans le repo). Stow avec `--adopt` fusionne nos fichiers par-dessus.

## Règles

- **Ne pas versionner** : `init.lua`, `lazy-lock.json`, `lazyvim.json` et les fichiers du starter LazyVim
- **Ajouter un nouveau module** : créer `<module>/.config/<module>/...` dans le repo, ajouter le `stow` dans install.sh
- **install.sh doit rester idempotent** : vérifier avant d'agir, backup avant d'écraser, ne jamais écraser silencieusement
- **macOS uniquement** : utiliser `gmd5sum` (coreutils) au lieu de `md5sum`

## Dépendances brew

neovim lazygit lazydocker ripgrep fd fzf node coreutils bottom stow gh

Cask : font-fira-code-nerd-font
