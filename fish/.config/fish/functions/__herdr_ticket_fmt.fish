function __herdr_ticket_fmt --argument-names ticket form --description "Formate un ticket : label (#507 / PR532), slug (i507 / pr532) ou suffix (507 / pr532)"
    test -n "$ticket"; or return 1
    if string match -qr '^[0-9]+$' -- $ticket
        switch $form
            case label; echo "#$ticket"
            case slug; echo "i$ticket"
            case suffix; echo "$ticket"
        end
    else
        switch $form
            case label; echo (string upper $ticket)
            case slug; echo $ticket
            case suffix; echo $ticket
        end
    end
end
