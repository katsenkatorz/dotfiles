
if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
end
function fish_greeting
end

# Secrets (tokens, credentials) — chargés depuis un fichier gitignored
if test -f ~/.config/fish/conf.d/secrets.fish
    source ~/.config/fish/conf.d/secrets.fish
end

function auto_nvm_use
    if test -f .node-version
        set node_version (cat .node-version)
        if not nvm ls $node_version >/dev/null 2>&1
            echo "Installing Node.js version $node_version..."
            nvm install $node_version
        end
        nvm use $node_version
    end
end

# Exécuter auto_nvm_use à chaque changement de répertoire
function on_cd --on-variable PWD
    auto_nvm_use
end

function startsockproxy
    echo "proxy started"
    ssh -D 8080 -M -S /tmp/proxy.sock -o ControlMaster=auto -o ControlPath=/tmp/proxy.sock -o ControlPersist=yes -CqNf ter.laposte.io
end

function stopsockproxy
    ssh -S /tmp/proxy.sock -o ControlMaster=auto -o ControlPath=/tmp/proxy.sock -O exit ter.laposte.io
    echo "proxy stopped"
end

function cleansocks
    # Vérifier si un argument est passé, sinon utiliser un pattern brut
    if test -n "$argv[1]"
        set -l socket_path "$argv[1]"
    else
        set -l socket_path "~/.ssh/173*" # Garder le pattern sous forme de chaîne
    end

    echo "Searching for SSH processes using ControlPath matching: $socket_path..."

    # Trouver les processus SSH qui utilisent ControlPath
    set -l pids (ps aux | grep ssh | grep "ControlPath=" | grep -F -- "$socket_path" | awk '{print $2}')

    if test -n "$pids"
        echo "Killing processes: $pids"
        for pid in $pids
            kill -9 $pid
            echo "Killed process $pid"
        end
    else
        echo "No matching SSH processes found."
    end

    echo "Removing socket files: $socket_path..."

    # Expansion sécurisée des fichiers avant suppression
    set -l files (eval echo $socket_path)

    if test -n "$files"
        rm -f $files 2>/dev/null; and echo "Sockets cleaned successfully." or echo "No socket files found to delete."
    else
        echo "No socket files found to delete."
    end
end

# Run auto_nvm_use when term is launch at first time
auto_nvm_use

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
