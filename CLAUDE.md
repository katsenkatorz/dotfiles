# Dotfiles : instructions pour Claude Code

## Projet

Repo dotfiles macOS géré avec GNU Stow. Deux volets :
- Terminal : Ghostty + Fish + Starship + LazyVim.
- Desktop : yabai + skhd (tiling clavier), barre de menu native + Spaceman
  (affichage des Spaces), JankyBorders, Homerow (clic clavier), herdr
  (sessions agents persistantes), clavier Dygma Defy (backup Bazecor versionné).

SketchyBar a été essayée puis retirée le 2026-08-19 (widgets custom bugués) :
ne pas la réintroduire sans demande explicite de Jeff.

## Structure

```
~/dotfiles/
├── install.sh                   # Script idempotent (brew + taps trustés, stow, services)
├── nvim/.config/nvim/lua/       # Customisations LazyVim uniquement (starter cloné par install.sh)
├── fish/.config/fish/           # config.fish, conf.d/ (herdr.fish = auto-attach), fish_plugins
├── starship/.config/
├── ghostty/.config/ghostty/
├── yabai/.config/yabai/         # yabairc (BSP, règles space par usage) + rules-msg.sh
├── skhd/.config/skhd/skhdrc     # Bindings vim sur alt, resize sur alt+uiop
├── borders/.config/borders/bordersrc  # JankyBorders, Sonokai, order=below
├── herdr/.config/herdr/config.toml
└── bazecor/                     # PAS un module Stow : backup Neuron du Defy + README
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
- **Couleurs bordures** : palette Sonokai dans `bordersrc`, pas d'accent hors palette
- **Après `brew upgrade yabai`** : régénérer la ligne sudoers `/private/etc/sudoers.d/yabai`
  (hash SHA-256 du binaire épinglé), sinon la scripting addition ne charge plus
  (runbook complet dans le README) ; tester aussi `space --create/--destroy`
  (cassés sur macOS 26.6, fix mergé non releasé : issue asmvik/yabai #2799)
- **Espaces par usage** : 1 web, 2 term, 3 code, 4 chat (fallback), 5 outils ;
  la messagerie suit l'écran MacBook quand il est présent (`rules-msg.sh`,
  signaux display_added/removed, écran identifié par UUID)
- **Recharger après modif** : `brew services restart felixkratz/formulae/borders`,
  `yabai --restart-service`, `skhd --restart-service`, `herdr server reload-config`
- **Backup Defy** : après un save Bazecor, copier le plus récent de
  `~/Dygma/Backups/Defy/<id>/` vers `bazecor/defy-backup.json` et committer

## Dépendances

Brew : neovim lazygit lazydocker ripgrep fd fzf node coreutils bottom stow gh
herdr + taps trustés felixkratz/formulae (borders) et koekeishiya/formulae
(yabai, skhd). Casks : font-fira-code-nerd-font, ghostty, gcloud-cli, bazecor,
homerow, spaceman.
