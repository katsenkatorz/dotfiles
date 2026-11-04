function ags --description "Liste les agents claude vus par tuios, puis les Tours et Ailiers du cockpit"
    echo "Agents dans un pane tuios :"
    tuios list-agents --select 'harness:claude' --json 2>/dev/null \
        | jq -r '.agents[]? | [.session, .name, .state, (if .identity == "report" then "declare" else "devine" end), .cwd] | @tsv' \
        | string replace -a "$HOME" '~' \
        | column -t -s (printf '\t')

    if command -q cockpit
        echo
        cockpit ls
    end
end
