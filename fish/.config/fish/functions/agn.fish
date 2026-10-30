function agn --description "Renomme les panes d'agents tuios d'apres leur numero de ticket"
    set -l rows (tuios list-agents --select 'harness:claude' --json 2>/dev/null \
        | jq -r '.agents[]? | [.session, .window_id, .cwd] | @tsv')
    if test -z "$rows"
        echo "agn: aucun agent claude dans un pane"
        return 0
    end

    # Sessions are not renamed: one can mix several folders, and tuios worktree
    # commands address a worktree session by its name.
    for row in $rows
        set -l f (string split \t -- $row)
        set -l session $f[1]; set -l win $f[2]; set -l dir $f[3]

        set -l ticket (__ag_ticket "$dir")
        if test -z "$ticket"
            echo "$session : aucun ticket ($dir)"
            continue
        end

        set -l label (__ag_ticket_fmt $ticket label)" "(basename "$dir")
        if tuios set-window -s $session -w $win --name "$label" >/dev/null 2>&1
            echo "$session : pane '$label'"
        else
            echo "$session : renommage impossible ($win)" >&2
        end
    end
end
