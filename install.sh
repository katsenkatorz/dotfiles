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
  ripgrep fd fzf coreutils bottom stow gh
  # Dev
  node php composer symfony-cli yarn docker docker-compose colima
  lazygit lazydocker glab
  # Agents (herdr : sessions persistantes pour agents de code)
  herdr
)
info "Installation/mise à jour des paquets brew..."
brew install "${FORMULAE[@]}" 2>/dev/null || true
ok "Paquets brew OK"

# ---------------------------------------------------------------------------
# 4. Casks & Nerd Font
# ---------------------------------------------------------------------------
CASKS=(font-fira-code-nerd-font font-jetbrains-mono-nerd-font ghostty gcloud-cli bazecor spaceman)
for cask in "${CASKS[@]}"; do
  if brew list --cask "$cask" &>/dev/null; then
    ok "$cask déjà installé"
  else
    info "Installation de $cask..."
    brew install --cask "$cask"
    ok "$cask installé"
  fi
done

# ---------------------------------------------------------------------------
# 5. Sauvegarder les configs existantes
# ---------------------------------------------------------------------------
backup_if_exists() {
  local target="$1"
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

for module in fish ghostty starship herdr nvim; do
  stow -v -d "$DOTFILES_DIR" -t "$HOME" "$module" 2>&1 | while read -r line; do
    info "  stow $module: $line"
  done
done

# Ghostty macOS : symlink vers Application Support (Ghostty lit depuis là, pas ~/.config)
GHOSTTY_APP_SUPPORT="$HOME/Library/Application Support/com.mitchellh.ghostty"
mkdir -p "$GHOSTTY_APP_SUPPORT"
ln -sf "$HOME/.config/ghostty/config" "$GHOSTTY_APP_SUPPORT/config"
ok "Symlink Ghostty → Application Support"

ok "Stow terminé"

# Spaceman affiche les Spaces dans la barre native (lancement au login
# a activer dans ses preferences au premier lancement)
open -a Spaceman 2>/dev/null || true

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
# 9. Skill herdr pour Claude Code
# ---------------------------------------------------------------------------
# Le binaire fait foi pour la syntaxe de son CLI : on regenere le skill a chaque
# install plutot que de versionner une copie qui derive a la prochaine version.
if command -v herdr >/dev/null 2>&1; then
  info "Synchronisation du skill herdr pour Claude Code..."
  mkdir -p "$HOME/.claude/skills/herdr"
  herdr --skill > "$HOME/.claude/skills/herdr/SKILL.md"
  ok "Skill herdr synchronise ($(herdr --version))"
else
  warn "herdr introuvable : skill Claude Code non synchronise"
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
echo -e "  ${BLUE}1.${NC} Relance Ghostty pour prendre la nouvelle font"
echo -e "  ${BLUE}2.${NC} Lance ${YELLOW}nvim${NC} : LazyVim installera ses plugins au premier démarrage"
echo -e "  ${BLUE}3.${NC} Dans nvim, lance ${YELLOW}:checkhealth${NC} pour vérifier"
echo -e "  ${BLUE}4.${NC} Crée ${YELLOW}~/.config/fish/conf.d/secrets.fish${NC} pour tes tokens/credentials"
echo ""
