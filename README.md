# dotfiles

Environnement macOS complet, géré avec [GNU Stow](https://www.gnu.org/software/stow/) :
Ghostty + Fish + LazyVim côté terminal (thème Catppuccin Mocha partout),
barre de menu native + Spaceman pour les Spaces côté desktop,
tuios pour les sessions d'agents persistantes (lancé par Ghostty),
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
gh, tuios, superfile, FiraCode Nerd Font. Casks : Bazecor, Spaceman, lazyworktree
(tap `chmouel/lazyworktree`).

## Structure du repo

```
~/dotfiles/
├── install.sh                   # Script d'installation idempotent
├── nvim/.config/nvim/           # Config LazyVim complète (cf. nvim/TUTO.md)
├── fish/.config/fish/           # config.fish, conf.d/, fish_plugins
├── starship/.config/            # Prompt Starship (catppuccin_mocha)
├── ghostty/.config/ghostty/     # Catppuccin Mocha, FiraCode Nerd Font
├── herdr/.config/herdr/         # Ancienne config herdr, plus installée (voir plus bas)
├── tuios/.config/tuios/         # Multiplexeur tuios (lié depuis Application Support)
├── superfile/.config/superfile/ # Gestionnaire de fichiers spf (lié depuis Application Support)
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

## tuios

Multiplexeur et sessions persistantes pour agents, outil par défaut depuis le
2026-10-30 (remplace herdr). La première fenêtre Ghostty ouvre `tuios attach`
(`initial-command`) : elle rejoint la dernière session, ou en crée une. Les
onglets suivants restent du fish simple. Prefix `Ctrl+B` ; `Ctrl+B i` ouvre la
vue Agents, `Ctrl+B U` crée une session dans un nouveau worktree, `Ctrl+B d` se
détache sans rien arrêter.

Il lit sa config dans `~/Library/Application Support/tuios/config.toml` :
`install.sh` y crée un symlink vers `~/.config/tuios/config.toml` (module Stow),
comme pour Ghostty. Seul le fichier est lié, jamais le dossier, où tuios range
aussi ses worktrees et ses sessions. Les `tuios set-config` passent par le
symlink et modifient donc le fichier du repo : committer après un réglage.

Quatre fonctions fish accompagnent ce flux (`fish/.config/fish/functions/`).
Elles marchent dans un pane tuios comme depuis un terminal hors tuios :
- `ag <nom> [chemin]` démarre un agent claude dans un pane, dans la session
  tuios qui a déjà un pane dans ce dossier (sinon la session courante) ;
- `ags` liste les agents claude vus par tuios (session, nom, état, `declare`
  par les hooks ou `devine` à l'écran), puis les sessions en arrière-plan de
  `claude agents` ;
- `aga <id>` ouvre une de ces sessions de fond (`claude attach`) dans la
  session tuios de son dossier, ou en crée une nommée `<dossier>-<ticket>` ;
- `agn` renomme les panes d'agents d'après leur ticket (`#507 <dossier>`).

Le ticket vient du corps de la PR de la branche (`Refs #N` / `Closes #N`), avec
repli sur le numero de PR ; `main`, `master` et `develop` sont exclus. `agn` ne
renomme jamais une session : une session tuios peut mêler plusieurs dossiers,
et `tuios worktree` désigne une session de worktree par son nom. Une session
ouverte par `aga` reste une session de fond : son état est deviné à l'écran,
pas déclaré par les hooks (ils ne trouvent pas son pane).

Couleurs : `theme = "none"` reprend les couleurs de Ghostty (Catppuccin Mocha,
fond `#0F0A1C`). C'est le seul mode où la vue Agents et les autres panneaux
prennent la teinte du fond ; avec un thème nommé, ils restent en gris neutre.

## superfile

Gestionnaire de fichiers en terminal, lancé par `spf` (`?` liste les raccourcis,
`q` quitte). Il lit sa config dans `~/Library/Application Support/superfile/` :
`install.sh` y lie `config.toml`, `hotkeys.toml` et `pinned.json` vers
`~/.config/superfile/` (module Stow). Le log, les contrôles de version et les
thèmes fournis restent locaux. superfile écrit ses fichiers à travers le lien
(`os.WriteFile`) : un dossier épinglé ou un réglage modifié dans l'app modifie
le repo, à committer.

## herdr (retiré le 2026-10-30)

Remplacé par tuios : plus installé ni lié par `install.sh`. Sa config reste dans
`herdr/` pour un retour éventuel (`brew install herdr && stow herdr`).

## Après l'installation

1. **Relance Ghostty** pour charger la font : la première fenêtre ouvre tuios
2. **Lance `nvim`** : LazyVim installe ses plugins au premier démarrage
3. **Spaceman** : active "Launch at login" dans ses préférences
4. **Dygma Defy** : restaure `bazecor/defy-backup.json` via Bazecor si besoin
5. **Crée `~/.config/fish/conf.d/secrets.fish`** pour tes tokens/credentials
