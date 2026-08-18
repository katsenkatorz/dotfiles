# dotfiles

Environnement macOS complet, géré avec [GNU Stow](https://www.gnu.org/software/stow/) :
Ghostty + Fish + LazyVim côté terminal, yabai + skhd + SketchyBar + JankyBorders
côté desktop (tiling clavier-first), herdr pour les sessions d'agents persistantes.

## Installation

```bash
git clone https://github.com/katsenkatorz/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Le script est **idempotent** : tu peux le relancer sans risque, il ne réinstalle et n'écrase rien.

Deux étapes restent manuelles sur une machine neuve (voir plus bas) :
les permissions **Accessibilité** de yabai/skhd, et la **scripting addition**
de yabai (désactivation partielle de SIP en recovery).

## Prérequis

- macOS (Apple Silicon)
- [Ghostty](https://ghostty.org/) installé
- [Fish shell](https://fishshell.com/) installé (`brew install fish`)

Le reste est installé automatiquement par `install.sh` :
neovim, lazygit, lazydocker, ripgrep, fd, fzf, node, coreutils, bottom, stow, gh,
herdr, media-control, lua, FiraCode Nerd Font, et depuis les taps tiers
(trustés par le script) : borders + sketchybar (felixkratz/formulae),
yabai + skhd (koekeishiya/formulae). SbarLua est compilé depuis les sources
et la police `sketchybar-app-font` est téléchargée dans `~/Library/Fonts`.

## Structure du repo

```
~/dotfiles/
├── install.sh                   # Script d'installation idempotent
├── nvim/.config/nvim/lua/       # Customisations LazyVim (starter cloné par install.sh)
├── fish/.config/fish/           # config.fish, conf.d/ (dont herdr.fish), fish_plugins
├── starship/.config/            # Prompt Starship
├── ghostty/.config/ghostty/     # Font FiraCode Nerd Font
├── yabai/.config/yabai/         # Tiling BSP, external_bar pour SketchyBar, scripting addition
├── skhd/.config/skhd/           # Bindings vim sur alt (focus, swap, spaces, resize)
├── sketchybar/.config/sketchybar/  # Config SbarLua (Lua), palette Sonokai
│   ├── sketchybarrc             # Point d'entrée (shebang lua)
│   ├── colors.lua               # Palette Sonokai (FelixKratz)
│   ├── icon_map.lua             # Mapping apps -> glyphes sketchybar-app-font
│   └── items/                   # spaces, front_app, media, calendar, widgets
├── borders/.config/borders/     # JankyBorders (bordures fenêtres, palette assortie)
└── herdr/.config/herdr/         # Sessions persistantes agents (thème, keybindings)
```

## Comment ça marche (GNU Stow)

Chaque dossier à la racine reproduit l'arborescence depuis `$HOME`.
`stow <module>` depuis `~/dotfiles` crée les symlinks ; éditer le fichier dans
le repo le rend actif immédiatement. Commit + push pour sauvegarder.

## Desktop : yabai + skhd + SketchyBar + JankyBorders

### Services

Tout tourne en service au login : `borders`, `sketchybar`, `herdr` via
`brew services`, `yabai` et `skhd` via leurs services launchd propres
(`yabai --start-service`, `skhd --start-service`). La barre de menu native
est masquée par `install.sh` (SketchyBar la remplace ; elle réapparaît en
survolant le haut de l'écran).

### Permissions (machine neuve)

yabai et skhd exigent la permission **Accessibilité**
(Réglages > Confidentialité et sécurité > Accessibilité), puis
`yabai --restart-service` et `skhd --restart-service`.

### Scripting addition yabai (Spaces au clavier)

Sans elle, le tiling et le focus fonctionnent, mais pas le changement de
Space (`alt+1..6`) ni l'envoi de fenêtre vers un Space (`alt+shift+1..6`).
L'activer = désactivation **partielle** de SIP (fs/debug/nvram ; l'intégrité
kernel reste protégée). Runbook :

1. Sudoers (le hash épingle le binaire yabai) :
   ```bash
   echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d ' ' -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
   ```
2. Recovery (power maintenu au boot) > Utilitaires > Terminal :
   `csrutil enable --without fs --without debug --without nvram`
3. Reboot normal, puis : `sudo nvram boot-args=-arm64e_preview_abi`
4. Reboot une seconde fois.

Le `yabairc` charge l'addition au démarrage et la recharge au restart du Dock.

**Entretien** : après chaque `brew upgrade` de yabai, régénérer la ligne
sudoers (étape 1), le hash du binaire ayant changé.

### Raccourcis skhd (préfixe alt)

| Binding | Action |
|---|---|
| `alt + h/j/k/l` | Focus fenêtre ouest/sud/nord/est |
| `alt+shift + h/j/k/l` | Échanger les fenêtres |
| `alt + f` | Fullscreen dans le layout (zoom) |
| `alt+shift + f` | Fullscreen natif macOS |
| `alt + t` | Basculer en flottant (centré) |
| `alt + e` | Basculer le sens du split |
| `ctrl+alt + h/j/k/l` | Redimensionner |
| `alt+shift + r` | Rotation du layout |
| `alt+shift + 0` | Rééquilibrer |
| `alt + 1..6` | Aller au Space N |
| `alt+shift + 1..6` | Envoyer la fenêtre au Space N et suivre |
| `alt` + drag / clic droit drag | Déplacer / redimensionner à la souris |

### SketchyBar

Config **SbarLua** (Lua), palette Sonokai reprise des dotfiles de FelixKratz.
Spaces avec icônes des apps présentes (police `sketchybar-app-font`),
app active, Now Playing (via `media-control`, clic = play/pause), météo
(wttr.in), slider de volume en popup (clic ; clic droit = mute, molette =
réglage), popup Wi-Fi (SSID + IP + réglages), CPU, RAM, batterie colorée
par niveau, horloge. Recharger après modification : `sketchybar --reload`.

Le SSID est lu via `system_profiler` : `ipconfig` renvoie `<redacted>`
pour un process sans permission Localisation.

### JankyBorders

Bordures assorties à la palette (actif blanc cassé, inactif gris).
`order=below` : les bordures passent sous les fenêtres, ce qui garde
l'animation Mission Control propre. Config : `borders/.config/borders/bordersrc`,
appliquer avec `brew services restart felixkratz/formulae/borders`.

## herdr

Serveur de sessions persistantes pour agents (Claude Code, etc.), en service
au login. `fish/conf.d/herdr.fish` attache automatiquement la session dans
tout shell interactif (garde anti-récursion sur `HERDR_ENV`). Prefix `Ctrl+B` ;
`Ctrl+B ?` liste les raccourcis ; `Ctrl+B Shift+O` ouvre un worktree git
existant (dont les worktrees Claude Code).

## Après l'installation

1. **Relance Ghostty** pour charger la font (herdr s'attache automatiquement)
2. **Lance `nvim`** : LazyVim installe ses plugins au premier démarrage
3. **Accorde l'Accessibilité** à yabai et skhd, relance leurs services
4. **Scripting addition** : déroule le runbook SIP ci-dessus si tu veux les Spaces au clavier
5. **Crée `~/.config/fish/conf.d/secrets.fish`** pour tes tokens/credentials
