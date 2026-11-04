function ag --description "Lance un Ailier avec cockpit agent : worktree, session tuios et tache"
    if not command -q cockpit
        echo "ag : la commande cockpit est absente." >&2
        echo "  installe-la : ~/Developer/Labs/tuios-cockpit/scripts/install.sh" >&2
        return 127
    end
    if test (count $argv) -lt 3
        echo "usage : ag <repo> <branche> \"<tache>\" [--model <m>] [--mission <id>]" >&2
        echo "  les repos viennent du registre ~/.config/tuios-cockpit/repos.json" >&2
        return 2
    end
    cockpit agent $argv
end
