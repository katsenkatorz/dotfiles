function __herdr_ticket --argument-names dir --description "Numero de ticket d'un dossier : 507 pour une issue, pr532 a defaut, vide sinon"
    test -n "$dir"; or return 1
    # La branche locale d'un worktree Claude Code (worktree-<nom>) ne correspond
    # pas a la branche poussee : l'upstream fait foi quand il existe.
    set -l branch (git -C "$dir" rev-parse --abbrev-ref '@{upstream}' 2>/dev/null | string replace -r '^[^/]+/' '')
    if test -z "$branch"
        set branch (git -C "$dir" branch --show-current 2>/dev/null)
    end
    test -n "$branch"; or return 1

    # main/develop ne sont pas des chantiers : leur PR de release porterait son
    # issue sur le checkout principal.
    switch $branch
        case main master develop
            return 1
    end
    set -l url (git -C "$dir" remote get-url origin 2>/dev/null)
    test -n "$url"; or return 1

    set -l repo (string replace -r '^.*[:/]([^/:]+/[^/]+?)(\.git)?$' '$1' -- $url)
    set -l json (gh pr list --repo $repo --head $branch --state all --json number,body --jq '.[0]' 2>/dev/null)
    test -n "$json" -a "$json" != null; or return 1

    # L'issue fait foi : une PR n'est pas un ticket, un chantier peut en avoir plusieurs.
    set -l issue (echo $json | jq -r '.body // ""' | grep -oE '(Refs|Closes|Fixes|Resolves) #[0-9]+' | head -n1 | grep -oE '[0-9]+')
    if test -n "$issue"
        echo $issue
    else
        echo "pr"(echo $json | jq -r '.number')
    end
end
