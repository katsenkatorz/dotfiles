# dotfiles

Config terminal macOS : Ghostty + Fish + LazyVim, géré avec [GNU Stow](https://www.gnu.org/software/stow/).

## Installation

```bash
git clone https://github.com/katsenkatorz/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Le script est **idempotent** — tu peux le relancer sans risque, il ne réinstalle/n'écrase rien.

## Prérequis

- macOS (Apple Silicon ou Intel)
- [Ghostty](https://ghostty.org/) installé
- [Fish shell](https://fishshell.com/) installé (`brew install fish`)

Le reste est installé automatiquement par `install.sh` :
neovim, lazygit, lazydocker, ripgrep, fd, fzf, node, coreutils, bottom, stow, gh, FiraCode Nerd Font.

## Structure du repo

```
~/dotfiles/
├── install.sh              # Script d'installation idempotent
├── nvim/.config/nvim/lua/
│   ├── config/options.lua  # Options Neovim custom
│   └── plugins/
│       ├── extras.lua      # Extras LazyVim (PHP, TS, Tailwind, Docker...)
│       └── ui.lua          # Thème, lualine, mini-starter
├── fish/.config/fish/       # config.fish, conf.d/, fish_plugins
├── starship/.config/        # Prompt Starship (Catppuccin Mocha)
└── ghostty/.config/ghostty/
    └── config              # Font FiraCode Nerd Font
```

Seules les **customisations** Neovim sont versionnées. Le starter LazyVim est cloné par `install.sh`, puis nos fichiers sont symlinkés par-dessus avec Stow.

## Comment ça marche (GNU Stow)

Chaque dossier à la racine (`nvim/`, `fish/`, `ghostty/`, `starship/`) reproduit l'arborescence depuis `$HOME`. Quand on lance `stow fish` depuis `~/dotfiles`, les fichiers sous `fish/.config/fish/` sont symlinkés vers `~/.config/fish/`.

Pour modifier une config : édite le fichier dans `~/dotfiles/`, le symlink le rend actif immédiatement. Commit + push pour sauvegarder.

## Après l'installation

1. **Relance Ghostty** pour charger la nouvelle font
2. **Lance `nvim`** : LazyVim installe ses plugins automatiquement au premier démarrage
3. **Dans nvim** : `:checkhealth` pour vérifier que tout est OK
4. **Crée `~/.config/fish/conf.d/secrets.fish`** pour tes tokens/credentials
