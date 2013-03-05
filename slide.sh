#!/bin/bash

declare -r TPUT=$(which tput)
[ -n "$TPUT" ] || exit 1

declare -r COLS=$($TPUT cols)
declare -r ROWS=$($TPUT lines)
declare -r IFS=''

$TPUT clear

function slide() {
    MESSAGE="${1:-Press enter for next slide...}"
    $TPUT cup 0 0

    while read LINE; do
        echo "$LINE"
    done

    $TPUT cup $ROWS $(($COLS-$(echo $MESSAGE | wc -c)))
    read -p "$MESSAGE" < /dev/tty
    
    $TPUT clear
}
