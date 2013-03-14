#!/bin/bash
function slide() {
    local -r TPUT=$(type -p tput)
    [ -x "$TPUT" ] || exit 1
    local -r IFS=''
    local -r MESSAGE=${1:-<Enter> Next slide | <ctrl+c> Quit}
    local -ri COLS=$($TPUT cols)
    local -ri ROWS=$($TPUT lines)
    local -i CENTER=0
    local -i LINENUM=0

    trap "$TPUT clear" 0
    $TPUT clear

    while read LINE; do
        [ "$LINE" == '!!center' ] && CENTER=1 && continue
        [ "$LINE" == '!!nocenter' ] && CENTER=0 && continue
        [ "$LINE" == '!!pause' ] && read -s < /dev/tty && continue
        [ "$LINE" == '!!sep' ] && printf -vLINE "%${COLS}s" '' && LINE=${LINE// /-}
        [ $CENTER -eq 1 ] && $TPUT cup $LINENUM $((($COLS-${#LINE})/2))
        printf "%s\n" "$LINE"
        let LINENUM++
    done
    $TPUT cup $ROWS $((($COLS-1)-${#MESSAGE})) && printf "$MESSAGE"
    read -s < /dev/tty
}
