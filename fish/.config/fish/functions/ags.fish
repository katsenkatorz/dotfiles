function ags --description "Liste les agents claude vus par tuios, puis ceux en arriere-plan sans pane"
    echo "Agents dans un pane tuios :"
    tuios list-agents --select 'harness:claude' --json 2>/dev/null \
        | jq -r '.agents[]? | [.session, .name, .state, (if .identity == "report" then "declare" else "devine" end), .cwd] | @tsv' \
        | string replace -a "$HOME" '~' \
        | column -t -s (printf '\t')

    # kind != background: an interactive session shows up here with null id and state.
    set -l bg (claude agents --json 2>/dev/null | jq -r '.[] | select(.kind == "background") | [.id, .state, (.name // "-")] | @tsv')
    if test -n "$bg"
        echo
        echo "Sessions en arriere-plan (aga <id> pour les ouvrir dans un pane) :"
        printf '%s\n' $bg | column -t -s (printf '\t')
    end
end
