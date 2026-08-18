# Dotfiles : instructions pour Claude Code

## Projet

Repo dotfiles macOS géré avec GNU Stow. Deux volets :
- Terminal : Ghostty + Fish + Starship + LazyVim.
- Desktop : yabai + skhd (tiling clavier), SketchyBar (SbarLua, palette Sonokai),
  JankyBorders, herdr (sessions agents persistantes), barre de menu native masquée.

## Structure

```
~/dotfiles/
├── install.sh                   # Script idempotent (brew + taps trustés, stow, services, SbarLua, fonts)
├── nvim/.config/nvim/lua/       # Customisations LazyVim uniquement (starter cloné par install.sh)
├── fish/.config/fish/           # config.fish, conf.d/ (herdr.fish = auto-attach), fish_plugins
├── starship/.config/
├── ghostty/.config/ghostty/
├── yabai/.config/yabai/yabairc  # BSP, external_bar 36pt, scripting addition (--load-sa)
├── skhd/.config/skhd/skhdrc     # Bindings vim sur alt
├── sketchybar/.config/sketchybar/  # Lua : sketchybarrc, colors.lua, icon_map.lua, items/
├── borders/.config/borders/bordersrc
└── herdr/.config/herdr/config.toml
```

## Convention Stow

Chaque dossier racine reproduit l'arborescence depuis `$HOME`. `stow <module>`
crée les symlinks. Nouveau module = créer `<module>/.config/...`, l'ajouter à la
boucle Stow d'install.sh. Pour nvim : ne versionner que les customisations
(starter cloné par install.sh, stow `--adopt` fusionne par-dessus).

## Règles

- **Ne pas versionner** : `init.lua`, `lazy-lock.json`, `lazyvim.json`, fichiers du starter LazyVim
- **install.sh doit rester idempotent** : vérifier avant d'agir, backup avant d'écraser
- **macOS uniquement** : `gmd5sum` (coreutils) au lieu de `md5sum`
- **SketchyBar est en Lua (SbarLua)** : pas de scripts shell dans plugins/, la logique vit dans items/*.lua
- **Couleurs** : palette Sonokai centralisée dans `sketchybar/colors.lua` et reprise dans `bordersrc` ; ne pas réintroduire d'accent hors palette
- **Glyphes Nerd Font** : caractères en zone privée Unicode, faciles à perdre en copiant/portant du code ; vérifier avec `sketchybar --query <item>` que `icon.value` n'est pas vide
- **Piège SSID** : `ipconfig` renvoie `<redacted>` sans permission Localisation, lire le SSID via `system_profiler SPAirPortDataType`
- **Après `brew upgrade yabai`** : régénérer la ligne sudoers `/private/etc/sudoers.d/yabai` (hash SHA-256 du binaire épinglé), sinon la scripting addition ne charge plus (voir README, section runbook)
- **Recharger après modif** : `sketchybar --reload`, `brew services restart felixkratz/formulae/borders`, `yabai --restart-service`, `skhd --restart-service`, `herdr server reload-config`

## Dépendances

Brew : neovim lazygit lazydocker ripgrep fd fzf node coreutils bottom stow gh
herdr media-control lua + taps trustés felixkratz/formulae (borders, sketchybar)
et koekeishiya/formulae (yabai, skhd). Cask : font-fira-code-nerd-font.
Hors brew : SbarLua compilé depuis les sources, sketchybar-app-font dans
~/Library/Fonts (les deux gérés par install.sh).
