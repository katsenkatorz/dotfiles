function agn --description "Recale agents, tabs et workspaces sur leur numero de ticket"
    if test "$HERDR_ENV" != "1"
        echo "agn: a lancer depuis un pane herdr" >&2
        return 1
    end

    set -l rows (herdr agent list | jq -r '.result.agents[] | [.pane_id, .tab_id, .workspace_id, .cwd] | @tsv')
    if test -z "$rows"
        echo "agn: aucun agent dans un pane"
        return 0
    end

    for row in $rows
        set -l f (string split \t -- $row)
        set -l pane $f[1]; set -l tab $f[2]; set -l ws $f[3]; set -l dir $f[4]

        set -l ticket (__herdr_ticket "$dir")
        if test -z "$ticket"
            echo "$pane : aucun ticket ($dir)"
            continue
        end

        set -l base (basename "$dir")
        set -l label (__herdr_ticket_fmt $ticket label)
        set -l slug (__herdr_ticket_fmt $ticket slug)
        set -l suffix (__herdr_ticket_fmt $ticket suffix)

        # Le nom d'agent est contraint a 32 caracteres et doit commencer par une lettre.
        set -l name (string sub -l 32 -- "$slug-$base")
        herdr agent rename $pane $name >/dev/null 2>&1
        herdr tab rename $tab "$label $base" >/dev/null 2>&1

        # Suffixe sur le workspace, et seulement pour un worktree : le checkout
        # principal garde son nom.
        set -l linked (herdr workspace list | jq -r --arg w "$ws" '.result.workspaces[] | select(.workspace_id == $w) | .worktree.is_linked_worktree // false')
        if test "$linked" = true
            herdr workspace rename $ws "$base-$suffix" >/dev/null 2>&1
            echo "$pane : $name  |  tab '$label $base'  |  workspace '$base-$suffix'"
        else
            echo "$pane : $name  |  tab '$label $base'"
        end
    end
end
