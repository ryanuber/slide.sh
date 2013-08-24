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
    local -i BOLD=0
    local -i CTRPOS=0
    local -i MSGPOS=0
    local COLOR=''
    trap "$TPUT clear" 0
    $TPUT clear
    while read LINE; do
        [ "$LINE" == '!!center' ]   && CENTER=1 && continue
        [ "$LINE" == '!!nocenter' ] && CENTER=0 && continue
        [ "$LINE" == '!!pause' ] && read -s < /dev/tty && continue
        [ "$LINE" == '!!sep' ] && printf -vLINE "%${COLS}s" '' && LINE=${LINE// /-}
        [ "$LINE" == '!!bold' ]     && BOLD=1      && continue
        [ "$LINE" == '!!nobold' ]   && BOLD=0      && continue
        [ "$LINE" == '!!red' ]      && COLOR=';31' && continue
        [ "$LINE" == '!!green' ]    && COLOR=';32' && continue
        [ "$LINE" == '!!yellow' ]   && COLOR=';33' && continue
        [ "$LINE" == '!!blue' ]     && COLOR=';34' && continue
        [ "$LINE" == '!!cyan' ]     && COLOR=';36' && continue
        [ "$LINE" == '!!purple' ]   && COLOR=';35' && continue
        [ "$LINE" == '!!darkgrey' ] && COLOR=';30' && continue
        [ "$LINE" == '!!nocolor' ]  && COLOR=';0'  && continue
        [ ${#MESSAGE} -lt $COLS ]   && MSGPOS=$(((COLS-1)-${#MESSAGE}))
        [ ${#LINE} -le $COLS ]      && CTRPOS=$(((COLS-${#LINE})/2))
        [ $CENTER -eq 1 ] && $TPUT cup $LINENUM $CTRPOS || $TPUT cup $LINENUM 0
        printf "\033[${BOLD}${COLOR}m${LINE//%/%%}\033[0m\n"
        [ "$COLOR" == ';0' ] && COLOR=''
        $TPUT cup $ROWS $COLS && let LINENUM++
        [ ${#LINE} -gt $COLS ] && let LINENUM++
    done
    $TPUT cup $ROWS $MSGPOS && printf "\033[0m$MESSAGE"
    read -s < /dev/tty
}
