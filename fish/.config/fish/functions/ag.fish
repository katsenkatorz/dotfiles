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

    set -l pane (herdr tab create --workspace $HERDR_WORKSPACE_ID --cwd "$dir" --label "$name" --no-focus | jq -r '.result.root_pane.pane_id')
    if test -z "$pane" -o "$pane" = "null"
        echo "ag: creation du tab impossible" >&2
        return 1
    end

    # Un agent ne naît visible que dans un pane : demarre ici, jamais en --bg.
    if not herdr agent start "$name" --kind claude --pane "$pane" >/dev/null
        echo "ag: l'agent n'a pas demarre dans $pane (tab conserve pour diagnostic)" >&2
        return 1
    end

    echo "agent '$name' demarre dans $pane"
    echo "  dossier : $dir"
    echo "  parler  : herdr agent prompt $name \"...\" --wait"
end
