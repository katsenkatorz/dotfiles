# dotfiles

Environnement macOS complet, géré avec [GNU Stow](https://www.gnu.org/software/stow/) :
Ghostty + Fish + LazyVim côté terminal, yabai + skhd + JankyBorders côté desktop
(tiling clavier-first, barre de menu native + Spaceman pour les Spaces),
Homerow pour cliquer au clavier, herdr pour les sessions d'agents persistantes,
et le backup du clavier Dygma Defy.

## Installation

```bash
git clone https://github.com/katsenkatorz/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Le script est **idempotent** : tu peux le relancer sans risque, il ne réinstalle et n'écrase rien.

Deux étapes restent manuelles sur une machine neuve (voir plus bas) :
les permissions **Accessibilité** (yabai, skhd, Homerow), et la **scripting
addition** de yabai (désactivation partielle de SIP en recovery).

## Prérequis

- macOS (Apple Silicon)
- [Ghostty](https://ghostty.org/) installé
- [Fish shell](https://fishshell.com/) installé (`brew install fish`)

Le reste est installé automatiquement par `install.sh` :
neovim, lazygit, lazydocker, ripgrep, fd, fzf, node, coreutils, bottom, stow,
gh, herdr, FiraCode Nerd Font, et depuis les taps tiers (trustés par le
script) : borders (felixkratz/formulae), yabai + skhd (koekeishiya/formulae).
Casks : Bazecor, Homerow, Spaceman.

## Structure du repo

```
~/dotfiles/
├── install.sh                   # Script d'installation idempotent
├── nvim/.config/nvim/           # Config LazyVim complète (cf. nvim/TUTO.md)
├── fish/.config/fish/           # config.fish, conf.d/ (dont herdr.fish), fish_plugins
├── starship/.config/            # Prompt Starship
├── ghostty/.config/ghostty/     # Font FiraCode Nerd Font
├── yabai/.config/yabai/         # yabairc (BSP, règles par usage) + rules-msg.sh
├── skhd/.config/skhd/skhdrc     # Bindings vim sur alt (focus, swap, spaces, resize)
├── borders/.config/borders/     # JankyBorders (bordures fenêtres, Sonokai)
├── herdr/.config/herdr/         # Sessions persistantes agents (thème, keybindings)
└── bazecor/                     # Backup Neuron du Dygma Defy (pas un module Stow)
```

## Comment ça marche (GNU Stow)

Chaque dossier à la racine reproduit l'arborescence depuis `$HOME`.
`stow <module>` depuis `~/dotfiles` crée les symlinks ; éditer le fichier dans
le repo le rend actif immédiatement. Commit + push pour sauvegarder.

## Desktop : yabai + skhd + JankyBorders + Spaceman

### Services

`borders` et `herdr` tournent en service au login via `brew services`,
`yabai` et `skhd` via leurs services launchd propres (`yabai --start-service`,
`skhd --start-service`). Spaceman affiche les Spaces dans la barre de menu
native (activer "Launch at login" dans ses préférences au premier lancement).

### Permissions (machine neuve)

yabai, skhd et Homerow exigent la permission **Accessibilité**
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
sudoers (étape 1), le hash du binaire ayant changé. Vérifier aussi
`space --create/--destroy` : cassés sur macOS 26.6, fix mergé non releasé
(issue asmvik/yabai #2799).

### Spaces par usage

Règles yabai : 1 web (Arc), 2 term (Ghostty), 3 code (PhpStorm/WebStorm/Xcode),
4 chat (fallback), 5 outils (Figma/Obsidian). Les jeux ne sont jamais tilés.
La messagerie (Discord/Telegram/Teams) suit l'écran intégré du MacBook quand
il est présent et se replie sur le Space 4 en clamshell (`rules-msg.sh`,
branché sur les signaux display_added/removed, écran identifié par UUID).

### Raccourcis skhd (préfixe alt, portés par la layer 4 du Defy)

| Binding | Action |
|---|---|
| `alt + h/j/k/l` | Focus fenêtre ouest/sud/nord/est |
| `alt+shift + h/j/k/l` | Échanger les fenêtres |
| `alt + u/i/o/p` | Redimensionner (largeur : u/p, hauteur : i/o) |
| `alt + f` | Fullscreen dans le layout (zoom) |
| `alt+shift + f` | Fullscreen natif macOS |
| `alt + t` | Basculer en flottant (centré) |
| `alt + e` | Basculer le sens du split |
| `alt+shift + r` | Rotation du layout |
| `alt+shift + 0` | Rééquilibrer |
| `alt + 1..6` | Aller au Space N |
| `alt+shift + 1..6` | Envoyer la fenêtre au Space N et suivre |
| `alt` + drag / clic droit drag | Déplacer / redimensionner à la souris |

### JankyBorders

Bordures Sonokai (actif blanc cassé, inactif gris), `order=below` pour garder
l'animation Mission Control propre. Config : `borders/.config/borders/bordersrc`,
appliquer avec `brew services restart felixkratz/formulae/borders`.

### Homerow

Clic au clavier : un raccourci fait apparaître des étiquettes sur tout élément
cliquable. Déclenché par `⌘+Shift+Espace` (touche pouce dédiée sur le Defy).

## Dygma Defy

Layout stocké dans l'EEPROM du clavier ; `bazecor/defy-backup.json` est le
backup complet du Neuron (voir `bazecor/README.md` pour restaurer/resynchroniser).
Layer 4 = fenêtres (chords `alt+` vers skhd/yabai), touche pouce = Homerow.

## herdr

Serveur de sessions persistantes pour agents (Claude Code, etc.), en service
au login. `fish/conf.d/herdr.fish` attache automatiquement la session dans
tout shell interactif (garde anti-récursion sur `HERDR_ENV`). Prefix `Ctrl+B` ;
`Ctrl+B ?` liste les raccourcis ; `Ctrl+B Shift+O` ouvre un worktree git
existant (dont les worktrees Claude Code).

## Après l'installation

1. **Relance Ghostty** pour charger la font (herdr s'attache automatiquement)
2. **Lance `nvim`** : LazyVim installe ses plugins au premier démarrage
3. **Accorde l'Accessibilité** à yabai, skhd et Homerow, relance les services
4. **Scripting addition** : déroule le runbook SIP ci-dessus pour les Spaces au clavier
5. **Spaceman** : active "Launch at login" dans ses préférences
6. **Dygma Defy** : restaure `bazecor/defy-backup.json` via Bazecor si besoin
7. **Crée `~/.config/fish/conf.d/secrets.fish`** pour tes tokens/credentials
