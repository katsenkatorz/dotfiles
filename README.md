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
├── fish/.config/fish/           # config.fish, conf.d/, fish_plugins
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

## Dygma Defy

Layout stocké dans l'EEPROM du clavier ; `bazecor/defy-backup.json` est le
backup complet du Neuron (voir `bazecor/README.md` pour restaurer/resynchroniser).

## herdr

Serveur de sessions persistantes pour agents (Claude Code, etc.), lancé à la
main : `herdr` démarre le serveur s'il ne tourne pas et attache la session
(ni service au login, ni attache automatique dans fish). Prefix `Ctrl+B` ;
`Ctrl+B ?` liste les raccourcis ; `Ctrl+B Shift+O` ouvre un worktree git
existant (dont les worktrees Claude Code).

`install.sh` synchronise aussi le skill Claude Code de herdr
(`herdr --skill` vers `~/.claude/skills/herdr/SKILL.md`) : c'est le binaire qui
fait foi pour la syntaxe du CLI, donc le skill est regenere a chaque install
plutot que versionne ici. Il donne aux agents le pilotage des panes, tabs,
workspaces et des autres agents (`herdr pane split`, `herdr pane run`,
`herdr agent prompt --wait`), et ne s'active que dans un pane herdr
(`HERDR_ENV=1`).

Deux fonctions fish accompagnent ce flux (`fish/.config/fish/functions/`) :
`ag <nom> [chemin]` cree un tab dans le workspace courant et y demarre un
agent claude nomme, et `ags` liste les agents vus par herdr puis les sessions
en arriere-plan qui n'ont pas de pane. Un agent doit NAITRE dans un pane :
seul ce cas fait declarer son etat par Claude Code (colonne `declare` de
`ags`). Une session dispatchee par `claude agents` puis rattachee avec
`claude attach` reste visible mais son etat est devine en lisant l'ecran,
donc un agent bloque peut s'y afficher comme termine.

## Après l'installation

1. **Relance Ghostty** pour charger la font, puis `herdr` pour ouvrir la session d'agents
2. **Lance `nvim`** : LazyVim installe ses plugins au premier démarrage
3. **Spaceman** : active "Launch at login" dans ses préférences
4. **Dygma Defy** : restaure `bazecor/defy-backup.json` via Bazecor si besoin
5. **Crée `~/.config/fish/conf.d/secrets.fish`** pour tes tokens/credentials
