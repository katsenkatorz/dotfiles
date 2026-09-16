function ag --description "Demarre un agent claude dans un pane herdr du workspace courant"
    if test "$HERDR_ENV" != "1"
        echo "ag: a lancer depuis un pane herdr" >&2
        return 1
    end

    set -l name $argv[1]
    if test -z "$name"
        echo "usage: ag <nom> [chemin]" >&2
        echo "  le nom doit matcher [a-z][a-z0-9_-]{0,31} et etre unique parmi les agents vivants" >&2
        return 2
    end

    set -l dir (pwd)
    if test (count $argv) -ge 2
        set dir $argv[2]
    end

    # Prefixe de ticket des la creation : le rail le porte, le nom d'agent aussi.
    set -l ticket (__herdr_ticket "$dir")
    set -l label "$name"
    set -l agent_name "$name"
    if test -n "$ticket"
        set label (__herdr_ticket_fmt $ticket label)" $name"
        set agent_name (string sub -l 32 -- (__herdr_ticket_fmt $ticket slug)"-$name")
    end

    # Le chantier a son propre workspace des qu'il est ouvert : y naitre plutot
    # que d'atterrir dans celui d'ou la commande est tapee.
    set -l ws (herdr workspace list | jq -r --arg d "$dir" '.result.workspaces[] | select(.worktree.checkout_path == $d) | .workspace_id' | head -n1)
    test -n "$ws"; or set ws $HERDR_WORKSPACE_ID

    set -l pane (herdr tab create --workspace $ws --cwd "$dir" --label "$label" --no-focus | jq -r '.result.root_pane.pane_id')
    if test -z "$pane" -o "$pane" = "null"
        echo "ag: creation du tab impossible" >&2
        return 1
    end

    # Un agent ne naît visible que dans un pane : demarre ici, jamais en --bg.
    if not herdr agent start "$agent_name" --kind claude --pane "$pane" >/dev/null
        echo "ag: l'agent n'a pas demarre dans $pane (tab conserve pour diagnostic)" >&2
        return 1
    end

    echo "agent '$agent_name' demarre dans $pane (workspace $ws)"
    echo "  dossier : $dir"
    echo "  parler  : herdr agent prompt $agent_name \"...\" --wait"
end
