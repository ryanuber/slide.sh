#!/bin/bash

declare -r TPUT=$(which tput)
[ -n "$TPUT" ] || exit 1

declare -r COLS=$($TPUT cols)
declare -r ROWS=$($TPUT lines)
declare -r IFS=''

function slide() {
    local MESSAGE='Press return for next slide'
    local CENTER=''
    local CENTERLINES=0
    local LINENUM=0
    local KEY=1

    $TPUT clear
    until [ -z "$*" ]; do
        case "$1" in
            --center)
                CENTER='true'
                if [[ "$2" =~ ^[0-9]+$ ]]; then
                    CENTERLINES=$2
                    shift
                fi
                ;;
            --message)
                MESSAGE="$2"
                shift
                ;;
        esac
        shift
    done
    while read LINE; do
        if [ -n "$CENTER" ] && [ $CENTERLINES -eq 0 -o $LINENUM -lt $CENTERLINES ]; then
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
