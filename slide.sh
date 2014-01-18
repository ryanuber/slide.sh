#!/bin/bash
function slide() {
    shopt -s extglob
    local -r TPUT=$(type -p tput)
    [ -x "$TPUT" ] || exit 1
    local -r IFS=''
    local -r MESSAGE=${1:-<Enter> Next slide | <ctrl+c> Quit}
    local -ri COLS=$($TPUT cols)
    local -ri ROWS=$($TPUT lines)
    local -i CENTER=0
    local -i LINENUM=0
    local -i CTRPOS=0
    local -i MSGPOS=0
    local -i HASCOLOR=1
    local COLOR=''
    trap "$TPUT clear" 0
    $TPUT clear
    while read LINE; do
        [ "$LINE" == '!!color' ] && HASCOLOR=1 && continue
        [ "$LINE" == '!!nocolor' ] && HASCOLOR=0 && continue
        if [ $HASCOLOR -eq 1 ]; then
            BARE=${LINE//<+([a-z])>/}
            LINE=${LINE//<red>/\\033[0;31m}
            LINE=${LINE//<green>/\\033[0;32m}
            LINE=${LINE//<yellow>/\\033[0;33m}
            LINE=${LINE//<blue>/\\033[0;34m}
            LINE=${LINE//<purple>/\\033[0;35m}
            LINE=${LINE//<cyan>/\\033[0;36m}
            LINE=${LINE//<darkgrey>/\\033[0;30m}
            LINE=${LINE//<end>/\\033[0m}
        else
            BARE=$LINE
        fi
        [ "$BARE" == '!!center' ] && CENTER=1 && continue
        [ "$BARE" == '!!nocenter' ] && CENTER=0 && continue
        [ "$BARE" == '!!pause' ] && read -s < /dev/tty && continue
        if [ "$BARE" == '!!sep' ]; then
            printf -vBARE "%${COLS}s" '' && BARE=${BARE// /-}
            LINE=${LINE//\!\!sep/$BARE}
        fi
        [ ${#MESSAGE} -lt $COLS ] && MSGPOS=$(((COLS-1)-${#MESSAGE}))
        [ ${#BARE} -le $COLS ] && CTRPOS=$(((COLS-${#BARE})/2))
        [ $CENTER -eq 1 ] && $TPUT cup $LINENUM $CTRPOS || $TPUT cup $LINENUM 0
        printf -- "${LINE//%/%%}\n"
        [ "$COLOR" == ';0' ] && COLOR=''
        $TPUT cup $ROWS $COLS && let LINENUM++
        [ ${#BARE} -gt $COLS ] && let LINENUM++
    done
    $TPUT cup $ROWS $MSGPOS && printf "\033[0m${MESSAGE}"
    read -s < /dev/tty
}
