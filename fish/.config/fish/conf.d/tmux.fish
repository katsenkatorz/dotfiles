# Auto-démarrer tmux dans Ghostty
# Commente ce bloc si tu veux utiliser Ghostty sans tmux le temps d'apprendre
if status is-interactive
    and not set -q TMUX
    and not set -q VSCODE_RESOLVING_ENVIRONMENT
    and test "$TERM_PROGRAM" = ghostty
    tmux new-session -A -s main
end
