#!/bin/bash

declare -r TPUT=$(which tput)
[ -n "$TPUT" ] || exit 1

declare -r COLS=$($TPUT cols)
declare -r ROWS=$($TPUT lines)
declare -r IFS=''

function slide() {
    local MESSAGE=${1:-Press return for next slide}
    local CENTER=0
    local LINENUM=0
    local KEY=1

    $TPUT clear
    
    while read LINE; do
        if [ "$LINE" == '!!pause' ]; then
            until [ "$KEY" == 'q' -o "$KEY" = '' ]; do
                read -s -n1 KEY < /dev/tty
            done
            [ "$KEY" == "q" ] && exit 0
            KEY=1
            continue
        fi
        if [ "$LINE" == '!!center' ]; then
            CENTER=1
            continue
        fi
        if [ "$LINE" == '!!nocenter' ]; then
            CENTER=0
            continue
        fi
        if [ $CENTER -eq 1 ]; then
            $TPUT cup $LINENUM $((($COLS-$(echo $LINE | wc -c))/2))
        fi
        echo "$LINE"
        let LINENUM++
    done
    until [ "$KEY" == 'q' -o "$KEY" = '' ]; do
        $TPUT cup $ROWS $(($COLS-$(echo $MESSAGE | wc -c)))
        read -s -n1 -p "$MESSAGE" KEY < /dev/tty
    done
    [ "$KEY" == "q" ] && exit 0
    $TPUT clear
}
