function aga --description "Attache un agent de fond dans un pane du workspace de son dossier"
    if test "$HERDR_ENV" != "1"
        echo "aga: a lancer depuis un pane herdr" >&2
        return 1
    end

    set -l id $argv[1]
    if test -z "$id"
        echo "usage: aga <id>   (ids listes par ags)" >&2
        return 2
    end

    set -l json (claude agents --json 2>/dev/null | jq -c --arg id "$id" '.[] | select(.kind == "background" and (.id // "") == $id)')
    if test -z "$json"
        echo "aga: aucune session de fond avec l'id $id" >&2
        return 1
    end

    set -l dir (echo $json | jq -r '.cwd')
    set -l name (echo $json | jq -r '.name // "agent"' | string sub -l 24)

    set -l ws (herdr workspace list | jq -r --arg d "$dir" '.result.workspaces[] | select(.worktree.checkout_path == $d) | .workspace_id' | head -n1)
    if test -z "$ws"
        # Ouvre le worktree en workspace : l'agent atterrit dans son chantier, pas dans le mien.
        set ws (herdr worktree open --cwd "$dir" --path "$dir" --label "$name" --no-focus 2>/dev/null | jq -r '.result.root_pane.workspace_id')
    end
    if test -z "$ws" -o "$ws" = "null"
        set ws $HERDR_WORKSPACE_ID
        echo "aga: workspace du dossier introuvable, repli sur $ws" >&2
    end

    set -l ticket (__herdr_ticket "$dir")
    set -l label "$name"
    if test -n "$ticket"
        set label (__herdr_ticket_fmt $ticket label)" $name"
        set -l linked (herdr workspace list | jq -r --arg w "$ws" '.result.workspaces[] | select(.workspace_id == $w) | .worktree.is_linked_worktree // false')
        if test "$linked" = true
            herdr workspace rename $ws (basename "$dir")"-"(__herdr_ticket_fmt $ticket suffix) >/dev/null 2>&1
        end
    end

    set -l pane (herdr tab create --workspace $ws --cwd "$dir" --label "$label" --no-focus | jq -r '.result.root_pane.pane_id')
    if test -z "$pane" -o "$pane" = "null"
        echo "aga: creation du tab impossible" >&2
        return 1
    end

    herdr pane run $pane "claude attach $id" >/dev/null
    echo "agent $id attache dans $pane (workspace $ws)"
    echo "  dossier : $dir"
end
