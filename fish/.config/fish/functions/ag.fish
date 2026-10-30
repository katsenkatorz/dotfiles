function ag --description "Demarre un agent claude dans un pane tuios, dans la session de son dossier"
    set -l name $argv[1]
    if test -z "$name"
        echo "usage: ag <nom> [chemin]" >&2
        return 2
    end

    set -l dir (pwd)
    if test (count $argv) -ge 2
        set dir (realpath $argv[2])
    end

    set -l label "$name"
    set -l ticket (__ag_ticket "$dir")
    if test -n "$ticket"
        set label (__ag_ticket_fmt $ticket label)" $name"
    end

    # The work has its own session once a pane is open in its folder: start the
    # agent there rather than in the session the command is typed from.
    set -l session (__ag_session_of "$dir")
    set -l target
    if test -n "$session"
        set target -s $session
    end

    # Born in a pane, never with --bg: only then do the hooks declare its state.
    if not tuios start-agent claude $target --cwd "$dir" --name "$label" >/dev/null
        echo "ag: l'agent n'a pas demarre dans $dir" >&2
        return 1
    end

    if test -n "$session"
        echo "agent '$label' demarre dans la session $session"
    else
        echo "agent '$label' demarre dans la session courante"
    end
    echo "  dossier : $dir"
    echo "  parler  : tuios ask-agent -w \"$label\" \"...\""
end
