#!/bin/bash

function slide() {
    local -r TPUT=$(type -p tput)
    [ -x "$TPUT" ] || exit 1
    local -r IFS=''
    local -r MESSAGE=${1:-<Enter> Next Slide | <q> Quit}
    local -ri COLS=$($TPUT cols)
    local -ri ROWS=$($TPUT lines)
    local -i CENTER=0
    local -i LINENUM=0
    local KEY=1

    $TPUT clear
    trap "$TPUT clear" 0

    while read LINE; do
        if [ "$LINE" == '!!pause' ]; then
            until [ "$KEY" == 'q' -o "$KEY" == '' ]; do
                read -s -n1 KEY < /dev/tty
            done
            [ "$KEY" == 'q' ] && exit 0 || KEY=1
            continue
        elif [ "$LINE" == '!!center' ]; then
            CENTER=1
            continue
        elif [ "$LINE" == '!!nocenter' ]; then
            CENTER=0
            continue
        elif [ "$LINE" == '!!sep' ]; then
            printf -vLINE "%${COLS}s" ''
            echo ${LINE// /-}
            let LINENUM++
            continue
        fi
        [ $CENTER -eq 1 ] && $TPUT cup $LINENUM $((($COLS-${#LINE})/2))
        echo "$LINE"
        let LINENUM++
    done
    until [ "$KEY" == 'q' -o "$KEY" = '' ]; do
        $TPUT cup $ROWS $((($COLS-1)-${#MESSAGE}))
        read -s -n1 -p "$MESSAGE" KEY < /dev/tty
    done
    [ "$KEY" == 'q' ] && exit 0
}
