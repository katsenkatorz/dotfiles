function aga --description "Ouvre un agent de fond dans un pane tuios de la session de son dossier"
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

    set -l label "$name"
    set -l ticket (__ag_ticket "$dir")
    if test -n "$ticket"
        set label (__ag_ticket_fmt $ticket label)" $name"
    end

    set -l session (__ag_session_of "$dir")
    if test -n "$session"
        tuios new-window -s $session "$label" --cwd "$dir" --no-focus -- claude attach $id >/dev/null
        or begin
            echo "aga: ouverture du pane impossible" >&2
            return 1
        end
        echo "agent $id ouvert dans la session $session"
    else
        # No session in that folder yet: give the work its own, named after the
        # folder and its ticket, so the agent lands in its work, not in mine.
        set session (basename "$dir")
        if test -n "$ticket"
            set session "$session-"(__ag_ticket_fmt $ticket suffix)
        end
        set -l params (jq -nc --arg n "$session" --arg c "$dir" --arg w "$label" --arg id "$id" \
            '{name: $n, cwd: $c, window_name: $w, command: ["claude", "attach", $id]}')
        tuios call new-session "$params" >/dev/null
        or begin
            echo "aga: creation de la session $session impossible (nom deja pris ?)" >&2
            return 1
        end
        echo "agent $id ouvert dans la nouvelle session $session"
    end
    echo "  dossier : $dir"
    echo "  etat devine a l'ecran : les hooks d'une session de fond ne trouvent pas ce pane"
end
