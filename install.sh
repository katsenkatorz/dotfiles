#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# install.sh : Dotfiles installer (idempotent)
# =============================================================================

DOTFILES_DIR="$HOME/dotfiles"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[dotfiles]${NC} $1"; }
ok()    { echo -e "${GREEN}[dotfiles]${NC} $1"; }
warn()  { echo -e "${YELLOW}[dotfiles]${NC} $1"; }
fail()  { echo -e "${RED}[dotfiles]${NC} $1"; exit 1; }

# ---------------------------------------------------------------------------
# 1. Vérifier macOS
# ---------------------------------------------------------------------------
if [[ "$(uname)" != "Darwin" ]]; then
  fail "Ce script est prévu pour macOS uniquement."
fi
ok "macOS détecté"

# ---------------------------------------------------------------------------
# 2. Installer Homebrew
# ---------------------------------------------------------------------------
if ! command -v brew &>/dev/null; then
  info "Installation de Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  ok "Homebrew installé"
else
  ok "Homebrew déjà installé"
fi

# ---------------------------------------------------------------------------
# 3. Paquets brew
# ---------------------------------------------------------------------------
FORMULAE=(
  # Terminal & navigation
  fish starship bat yazi zoxide television fastfetch btop tlrc taproom
  # Éditeur
  neovim tree-sitter
  # Recherche & outils
  ripgrep fd fzf coreutils bottom stow gh superfile
  # Dev
  node php composer symfony-cli yarn docker docker-compose colima
  lazygit lazydocker glab
  # Agents (tuios : multiplexeur et sessions persistantes pour agents de code)
  tuios
)
# One formula at a time: a single refusal in a batch call (a formula installed
# from another tap under the same name, an untrusted tap) skipped every other
# missing formula without a word. Installed means installed, whatever its tap.
INSTALLED_FORMULAE=$(brew list --formula -1)
MISSING=()
for formula in "${FORMULAE[@]}"; do
  grep -qx "$formula" <<<"$INSTALLED_FORMULAE" || MISSING+=("$formula")
done
FAILED=()
for formula in ${MISSING[@]+"${MISSING[@]}"}; do
  info "Installation de $formula..."
  brew install "$formula" || FAILED+=("$formula")
done
if [[ ${#FAILED[@]} -gt 0 ]]; then
  warn "Paquets brew en echec : ${FAILED[*]}"
elif [[ ${#MISSING[@]} -gt 0 ]]; then
  ok "Paquets brew installes : ${MISSING[*]}"
else
  ok "Paquets brew deja installes"
fi

# ---------------------------------------------------------------------------
# 4. Casks & Nerd Font
# ---------------------------------------------------------------------------
CASKS=(font-fira-code-nerd-font font-jetbrains-mono-nerd-font ghostty gcloud-cli bazecor)
for cask in "${CASKS[@]}"; do
  if brew list --cask "$cask" &>/dev/null; then
    ok "$cask déjà installé"
  else
    info "Installation de $cask..."
    brew install --cask "$cask"
    ok "$cask installé"
  fi
done

# lazyworktree is only published in its author's tap; Homebrew refuses to load
# a cask from an untrusted tap, so trust that single cask, not the whole tap.
if brew list --cask lazyworktree &>/dev/null; then
  ok "lazyworktree déjà installé"
else
  info "Installation de lazyworktree (tap chmouel/lazyworktree)..."
  brew tap chmouel/lazyworktree https://github.com/chmouel/lazyworktree
  brew trust --cask chmouel/lazyworktree/lazyworktree
  brew install --cask lazyworktree
  ok "lazyworktree installé"
fi

# ---------------------------------------------------------------------------
# 5. Sauvegarder les configs existantes
# ---------------------------------------------------------------------------
backup_if_exists() {
  local target="$1"
  # Through a stow-folded folder link (~/.config/ghostty -> repo), the file is
  # the repo's own copy: moving it would delete it from the repo.
  local real
  real=$(realpath "$target" 2>/dev/null || echo "$target")
  [[ "$real" == "$DOTFILES_DIR"/* ]] && return 0
  if [[ -e "$target" && ! -L "$target" ]]; then
    local backup="${target}.bak.${TIMESTAMP}"
    warn "Backup: $target → $backup"
    mv "$target" "$backup"
  fi
}

backup_if_exists "$HOME/.config/fish/config.fish"
backup_if_exists "$HOME/.config/fish/fish_plugins"
backup_if_exists "$HOME/.config/ghostty/config"
backup_if_exists "$HOME/.config/starship.toml"
backup_if_exists "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

# ---------------------------------------------------------------------------
# 6. GNU Stow
# ---------------------------------------------------------------------------
info "Lancement de GNU Stow..."

cd "$DOTFILES_DIR"

# nvim : la config LazyVim complète vit dans le repo, stow classique comme le reste
backup_if_exists "$HOME/.config/nvim"

for module in fish ghostty starship tuios superfile nvim; do
  stow -v -d "$DOTFILES_DIR" -t "$HOME" "$module" 2>&1 | while read -r line; do
    info "  stow $module: $line"
  done
done

# Ghostty macOS : symlink vers Application Support (Ghostty lit depuis là, pas ~/.config)
GHOSTTY_APP_SUPPORT="$HOME/Library/Application Support/com.mitchellh.ghostty"
mkdir -p "$GHOSTTY_APP_SUPPORT"
ln -sf "$HOME/.config/ghostty/config" "$GHOSTTY_APP_SUPPORT/config"
ok "Symlink Ghostty → Application Support"

# tuios macOS : il lit sa config dans Application Support, ou y range aussi ses
# worktrees et sessions. On ne lie que le fichier, jamais le dossier.
TUIOS_APP_SUPPORT="$HOME/Library/Application Support/tuios"
mkdir -p "$TUIOS_APP_SUPPORT"
backup_if_exists "$TUIOS_APP_SUPPORT/config.toml"
ln -sf "$HOME/.config/tuios/config.toml" "$TUIOS_APP_SUPPORT/config.toml"
ok "Symlink tuios → Application Support"

# superfile (spf) : meme principe, il ecrit aussi son log et ses controles de
# version dans ce dossier. Seuls les fichiers de reglages sont lies.
SPF_APP_SUPPORT="$HOME/Library/Application Support/superfile"
mkdir -p "$SPF_APP_SUPPORT"
for f in config.toml hotkeys.toml pinned.json; do
  backup_if_exists "$SPF_APP_SUPPORT/$f"
  ln -sf "$HOME/.config/superfile/$f" "$SPF_APP_SUPPORT/$f"
done
ok "Symlink superfile → Application Support"

ok "Stow terminé"

# ---------------------------------------------------------------------------
# 8. Installer Fisher + plugins fish
# ---------------------------------------------------------------------------
if fish -c "type -q fisher" 2>/dev/null; then
  ok "Fisher déjà installé"
else
  info "Installation de Fisher..."
  fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
  ok "Fisher installé"
fi

# Installer les plugins listés dans fish_plugins
if [[ -f "$HOME/.config/fish/fish_plugins" ]]; then
  info "Installation des plugins Fisher..."
  fish -c "fisher update" 2>/dev/null || true
  ok "Plugins Fisher OK"
fi

# ---------------------------------------------------------------------------
# 9. Integration Claude Code de tuios
# ---------------------------------------------------------------------------
# Hooks + skill tuios dans ~/.claude : `install` garde les reglages existants,
# sauvegarde settings.json en .tuios.bak et ne fait rien hors d'un pane tuios.
if command -v tuios >/dev/null 2>&1; then
  if tuios integration status claude-code 2>/dev/null | grep -q 'installed, current'; then
    ok "Integration Claude Code de tuios deja a jour"
  else
    info "Installation de l'integration Claude Code de tuios..."
    tuios integration install claude-code
    ok "Integration Claude Code de tuios installee"
  fi
else
  warn "tuios introuvable : integration Claude Code non installee"
fi

# ---------------------------------------------------------------------------
# 10. Résumé
# ---------------------------------------------------------------------------
echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Installation terminée !${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "Étapes manuelles restantes :"
echo -e "  ${BLUE}1.${NC} Relance Ghostty : nouvelle font, et la premiere fenetre ouvre tuios"
echo -e "  ${BLUE}2.${NC} Lance ${YELLOW}nvim${NC} : LazyVim installera ses plugins au premier démarrage"
echo -e "  ${BLUE}3.${NC} Dans nvim, lance ${YELLOW}:checkhealth${NC} pour vérifier"
echo -e "  ${BLUE}4.${NC} Crée ${YELLOW}~/.config/fish/conf.d/secrets.fish${NC} pour tes tokens/credentials"
echo ""
