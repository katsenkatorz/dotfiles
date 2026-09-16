function ags --description "Liste les agents claude vus par herdr, puis ceux en arriere-plan sans pane"
    echo "Agents dans un pane herdr :"
    herdr agent list \
        | jq -r '.result.agents[] | [.pane_id, .agent_status, (if .agent_session.source then "declare" else "devine" end), .cwd] | @tsv' \
        | column -t -s (printf '\t')

    set -l bg (claude agents --json 2>/dev/null | jq -r '.[] | [.id, .state, (.name // "-")] | @tsv')
    if test -n "$bg"
        echo
        echo "Sessions en arriere-plan (claude attach <id> dans un pane pour les voir) :"
        printf '%s\n' $bg | column -t -s (printf '\t')
    end
end
