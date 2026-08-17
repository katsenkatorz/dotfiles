# Auto-attach the persistent herdr session when opening a terminal.
# HERDR_ENV is set inside herdr panes: the guard prevents recursion.
# Not exec'd on purpose: detaching from herdr drops back to a fish prompt.
if status is-interactive; and not set -q HERDR_ENV; and command -q herdr
    herdr
end
