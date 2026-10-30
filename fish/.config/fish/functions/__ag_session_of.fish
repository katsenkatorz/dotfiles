function __ag_session_of --argument-names dir --description "Session tuios qui a deja un pane dans ce dossier, vide sinon"
    test -n "$dir"; or return 1
    tuios list-windows --all --json 2>/dev/null \
        | jq -r --arg d "$dir" '[.panes[]? | select(.cwd == $d) | .session] | first // empty'
end
