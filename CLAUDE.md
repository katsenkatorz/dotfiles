# Dotfiles : instructions pour Claude Code

## Projet

Repo dotfiles macOS géré avec GNU Stow. Deux volets :
- Terminal : Ghostty + Fish + Starship + LazyVim, thème Catppuccin Mocha partout
  (Ghostty, herdr, Neovim, Starship).
- Desktop : barre de menu native + Spaceman (affichage des Spaces), herdr
  (sessions agents persistantes), clavier Dygma Defy (backup Bazecor versionné).

Retirés, ne pas les réintroduire sans demande explicite de Jeff :
- SketchyBar, le 2026-08-19 (widgets custom bugués).
- yabai + skhd + JankyBorders, le 2026-09-15 (le tiling ne lui convenait pas),
  en même temps que le retour de night-owl vers Catppuccin Mocha.

## Structure

```
~/dotfiles/
├── install.sh                   # Script idempotent (brew, stow, services)
├── nvim/.config/nvim/           # Config LazyVim complète versionnée (cf. nvim/TUTO.md)
├── fish/.config/fish/           # config.fish, conf.d/ (herdr.fish = auto-attach), fish_plugins
├── starship/.config/
├── ghostty/.config/ghostty/
├── herdr/.config/herdr/config.toml
└── bazecor/                     # PAS un module Stow : backup Neuron du Defy + README
```

## Convention Stow

Chaque dossier racine reproduit l'arborescence depuis `$HOME`. `stow <module>`
crée les symlinks. Nouveau module = créer `<module>/.config/...`, l'ajouter à la
boucle Stow d'install.sh.

## Règles

- **install.sh doit rester idempotent** : vérifier avant d'agir, backup avant d'écraser
- **macOS uniquement** : `gmd5sum` (coreutils) au lieu de `md5sum`
- **Thème** : Catppuccin Mocha partout, pas de palette maison
- **Recharger après modif** : `herdr server reload-config`
- **Backup Defy** : après un save Bazecor, copier le plus récent de
  `~/Dygma/Backups/Defy/<id>/` vers `bazecor/defy-backup.json` et committer

## Dépendances

Brew : neovim lazygit lazydocker ripgrep fd fzf node coreutils bottom stow gh
herdr. Casks : font-fira-code-nerd-font, ghostty, gcloud-cli, bazecor, spaceman.
