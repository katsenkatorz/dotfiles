# dotfiles

Environnement macOS complet, géré avec [GNU Stow](https://www.gnu.org/software/stow/) :
Ghostty + Fish + LazyVim côté terminal (thème Catppuccin Mocha partout),
barre de menu native + Spaceman pour les Spaces côté desktop,
herdr pour les sessions d'agents persistantes,
et le backup du clavier Dygma Defy.

## Installation

```bash
git clone https://github.com/katsenkatorz/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Le script est **idempotent** : tu peux le relancer sans risque, il ne réinstalle et n'écrase rien.

## Prérequis

- macOS (Apple Silicon)
- [Ghostty](https://ghostty.org/) installé
- [Fish shell](https://fishshell.com/) installé (`brew install fish`)

Le reste est installé automatiquement par `install.sh` :
neovim, lazygit, lazydocker, ripgrep, fd, fzf, node, coreutils, bottom, stow,
gh, herdr, FiraCode Nerd Font. Casks : Bazecor, Spaceman.

## Structure du repo

```
~/dotfiles/
├── install.sh                   # Script d'installation idempotent
├── nvim/.config/nvim/           # Config LazyVim complète (cf. nvim/TUTO.md)
├── fish/.config/fish/           # config.fish, conf.d/ (dont herdr.fish), fish_plugins
├── starship/.config/            # Prompt Starship (catppuccin_mocha)
├── ghostty/.config/ghostty/     # Catppuccin Mocha, FiraCode Nerd Font
├── herdr/.config/herdr/         # Sessions persistantes agents (thème, keybindings)
└── bazecor/                     # Backup Neuron du Dygma Defy (pas un module Stow)
```

## Comment ça marche (GNU Stow)

Chaque dossier à la racine reproduit l'arborescence depuis `$HOME`.
`stow <module>` depuis `~/dotfiles` crée les symlinks ; éditer le fichier dans
le repo le rend actif immédiatement. Commit + push pour sauvegarder.

## Desktop

Pas de gestionnaire de fenêtres : yabai + skhd + JankyBorders ont été retirés
le 2026-09-15. Spaceman affiche les Spaces dans la barre de menu native
(activer "Launch at login" dans ses préférences au premier lancement).
`herdr` tourne en service au login via `brew services`.

## Dygma Defy

Layout stocké dans l'EEPROM du clavier ; `bazecor/defy-backup.json` est le
backup complet du Neuron (voir `bazecor/README.md` pour restaurer/resynchroniser).

## herdr

Serveur de sessions persistantes pour agents (Claude Code, etc.), en service
au login. `fish/conf.d/herdr.fish` attache automatiquement la session dans
tout shell interactif (garde anti-récursion sur `HERDR_ENV`). Prefix `Ctrl+B` ;
`Ctrl+B ?` liste les raccourcis ; `Ctrl+B Shift+O` ouvre un worktree git
existant (dont les worktrees Claude Code).

## Après l'installation

1. **Relance Ghostty** pour charger la font (herdr s'attache automatiquement)
2. **Lance `nvim`** : LazyVim installe ses plugins au premier démarrage
3. **Spaceman** : active "Launch at login" dans ses préférences
4. **Dygma Defy** : restaure `bazecor/defy-backup.json` via Bazecor si besoin
5. **Crée `~/.config/fish/conf.d/secrets.fish`** pour tes tokens/credentials
