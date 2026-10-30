# Dotfiles : instructions pour Claude Code

## Projet

Repo dotfiles macOS géré avec GNU Stow. Deux volets :
- Terminal : Ghostty + Fish + Starship + LazyVim, thème Catppuccin Mocha partout
  (Ghostty, Neovim, Starship ; tuios suit les couleurs de Ghostty).
- Desktop : barre de menu native + Spaceman (affichage des Spaces), tuios
  (multiplexeur et sessions agents persistantes, ouvert par la première
  fenêtre Ghostty via `initial-command = tuios attach` depuis le 2026-10-30),
  clavier Dygma Defy (backup Bazecor versionné).

Retirés, ne pas les réintroduire sans demande explicite de Jeff :
- SketchyBar, le 2026-08-19 (widgets custom bugués).
- yabai + skhd + JankyBorders, le 2026-09-15 (le tiling ne lui convenait pas),
  en même temps que le retour de night-owl vers Catppuccin Mocha.
- herdr, le 2026-10-30, remplacé par tuios : plus installé ni stowé ; sa config
  reste dans `herdr/`. Les fonctions fish `ag`, `ags`, `aga`, `agn` sont
  portées sur tuios (helpers `__ag_ticket*`, `__ag_session_of`).

## Structure

```
~/dotfiles/
├── install.sh                   # Script idempotent (brew, stow, services)
├── nvim/.config/nvim/           # Config LazyVim complète versionnée (cf. nvim/TUTO.md)
├── fish/.config/fish/           # config.fish, conf.d/, fish_plugins
├── starship/.config/
├── ghostty/.config/ghostty/
├── herdr/.config/herdr/config.toml  # retiré, plus stowé
├── tuios/.config/tuios/config.toml  # lié depuis ~/Library/Application Support/tuios/
├── superfile/.config/superfile/     # config spf, liée fichier par fichier depuis Application Support
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
- **Recharger tuios après modif du fichier** : `tuios config apply`
- **Config tuios** : symlink fichier par fichier depuis Application Support
  (install.sh), jamais le dossier entier (tuios y range worktrees et
  sessions). tuios réécrit le fichier en suivant le symlink (vérifié en
  0.11.1) : un `set-config` modifie donc le repo. `theme = "none"` est voulu
  (seul mode où les panneaux prennent la teinte du fond de Ghostty).
- **Config superfile** : même règle que tuios, seuls `config.toml`,
  `hotkeys.toml` et `pinned.json` sont liés (le dossier contient aussi log et
  état). superfile écrit via `os.WriteFile`, qui suit le lien.
- **Backup Defy** : après un save Bazecor, copier le plus récent de
  `~/Dygma/Backups/Defy/<id>/` vers `bazecor/defy-backup.json` et committer

## Dépendances

Brew : neovim lazygit lazydocker ripgrep fd fzf node coreutils bottom stow gh
tuios superfile. Casks : font-fira-code-nerd-font, ghostty, gcloud-cli, bazecor, spaceman,
lazyworktree (tap externe `chmouel/lazyworktree`, cask marqué de confiance par
`brew trust --cask`, jamais le tap entier).

tuios (multiplexeur par défaut depuis le 2026-10-30, à la place de herdr) :
`install.sh` installe son intégration Claude Code
(`tuios integration install claude-code` : hooks dans `~/.claude/settings.json`
+ skill `~/.claude/skills/tuios/`), retrait par `tuios integration uninstall
claude-code`. lazyworktree tire tmux en dépendance brew : c'est voulu, tmux
n'est pas réintroduit dans la config.
