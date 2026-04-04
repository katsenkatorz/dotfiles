# dotfiles

Config terminal macOS : Ghostty + Fish + tmux + LazyVim, géré avec [GNU Stow](https://www.gnu.org/software/stow/).

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
tmux, neovim, lazygit, lazydocker, ripgrep, fd, fzf, node, coreutils, bottom, stow, gh, JetBrainsMono Nerd Font.

## Structure du repo

```
~/dotfiles/
├── install.sh              # Script d'installation idempotent
├── tmux/.tmux.conf         # Config tmux (prefix Ctrl-a, popups, Tokyo Night)
├── nvim/.config/nvim/lua/
│   ├── config/options.lua  # Options Neovim custom
│   └── plugins/
│       ├── extras.lua      # Extras LazyVim (PHP, TS, Tailwind, Docker...)
│       └── tmux-navigator.lua
├── fish/.config/fish/conf.d/
│   └── tmux.fish           # Auto-start tmux dans Ghostty
└── ghostty/.config/ghostty/
    └── config              # Font JetBrainsMono Nerd Font
```

Seules les **customisations** Neovim sont versionnées. Le starter LazyVim est cloné par `install.sh`, puis nos fichiers sont symlinkés par-dessus avec Stow.

## Comment ça marche (GNU Stow)

Chaque dossier à la racine (`tmux/`, `nvim/`, `fish/`, `ghostty/`) reproduit l'arborescence depuis `$HOME`. Quand on lance `stow tmux` depuis `~/dotfiles`, le fichier `tmux/.tmux.conf` est symlinké vers `~/.tmux.conf`.

Pour modifier une config : édite le fichier dans `~/dotfiles/`, le symlink le rend actif immédiatement. Commit + push pour sauvegarder.

## Raccourcis tmux

Le prefix est **`Ctrl-a`** (au lieu du `Ctrl-b` par défaut).

### Popups (apps en overlay)

| Raccourci | Action |
|---|---|
| `Ctrl-a y` | Claude Code (session persistante par projet) |
| `Ctrl-a g` | LazyGit |
| `Ctrl-a d` | LazyDocker |
| `Ctrl-a e` | Neovim rapide |
| `Ctrl-a b` | bottom (monitoring) |

### Fenêtres et panes

| Raccourci | Action |
|---|---|
| `Ctrl-a v` | Split vertical |
| `Ctrl-a s` | Split horizontal |
| `Ctrl-a c` | Nouvelle fenêtre |
| `Ctrl-a z` | Zoom/dézoom un pane |
| `Ctrl-a x` | Fermer le pane courant |
| `Ctrl-a ,` | Renommer la fenêtre |
| `Ctrl-a 1-9` | Aller à la fenêtre N |

### Navigation

| Raccourci | Action |
|---|---|
| `Ctrl-h/j/k/l` | Navigation entre panes tmux et splits Neovim |
| `Ctrl-a h/j/k/l` | Navigation entre panes (prefix) |
| `Ctrl-a H/J/K/L` | Redimensionner les panes |

### Divers

| Raccourci | Action |
|---|---|
| `Ctrl-a r` | Recharger la config tmux |
| `Ctrl-a [` | Mode copie (navigation Vim) |
| `Ctrl-a ?` | Afficher tous les raccourcis |

## Concepts tmux pour débutant

### Vocabulaire

- **Session** : un espace de travail indépendant (ex: une session par projet). Persiste même si tu fermes Ghostty.
- **Window** : un onglet dans une session. Numéroté en bas de l'écran.
- **Pane** : un split à l'intérieur d'une fenêtre (vertical ou horizontal).
- **Popup** : une fenêtre flottante par-dessus tout (utilisée ici pour Claude Code, LazyGit, etc.).
- **Prefix** : la touche qu'il faut appuyer avant chaque raccourci tmux. Ici c'est `Ctrl-a`.

### Commandes de survie

```bash
# Lister les sessions
tmux ls

# Revenir dans une session existante
tmux attach -t main

# Créer une nouvelle session nommée
tmux new -s mon-projet

# Détacher de la session (sans la fermer)
# Ctrl-a d  (mais ici c'est pris par LazyDocker, utilise le menu Ctrl-a :detach)

# Tuer une session
tmux kill-session -t nom
```

### Workflow typique

1. Ouvre Ghostty → tmux démarre automatiquement (session `main`)
2. `Ctrl-a c` pour créer des fenêtres (un par tâche)
3. `Ctrl-a v` / `Ctrl-a s` pour splitter
4. `Ctrl-a y` pour ouvrir Claude Code en popup
5. `Ctrl-a g` pour ouvrir LazyGit en popup
6. Navigue entre panes avec `Ctrl-h/j/k/l`

## Après l'installation

1. **Relance Ghostty** pour charger la nouvelle font
2. **Dans tmux** : `Ctrl-a I` (majuscule) pour installer les plugins TPM
3. **Lance `nvim`** : LazyVim installe ses plugins automatiquement au premier démarrage
4. **Dans nvim** : `:checkhealth` pour vérifier que tout est OK
