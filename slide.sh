#!/bin/bash
function slide() {
    local -r TPUT=$(type -p tput)
    [ -x "$TPUT" ] || exit 1
    local -r IFS='' MESSAGE=${1:-<Enter> Next slide | <ctrl+c> Quit}
    local -r COLORS=(red=31 green=32 yellow=33 blue=34 purple=35 cyan=36 end=)
    local -ri COLS=$($TPUT cols) ROWS=$($TPUT lines)
    local -i CENTER=0 LINENUM=0 CTRPOS=0 MSGPOS=0 HASCOLOR=1
    local LINE='' BARE=''
    trap "$TPUT clear" 0
    $TPUT clear
    while read LINE; do
        [ "$LINE" == '!!color' ] && HASCOLOR=1 && continue
        [ "$LINE" == '!!nocolor' ] && HASCOLOR=0 && continue
        BARE=$LINE
        if [ $HASCOLOR -eq 1 ]; then
            for C in ${COLORS[@]}; do
                BARE=${BARE//<${C%%=*}>/}
                LINE=${LINE//<${C%%=*}>/\\033\[0\;${C##*=}m}
            done
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
        $TPUT cup $ROWS $COLS && let LINENUM++
        [ ${#BARE} -gt $COLS ] && let LINENUM++
    done
    $TPUT cup $ROWS $MSGPOS && printf "\033[0m${MESSAGE}"
}

function deck() {
    local -r FILES=($1/*.slide)
    local -ri TOTAL=${#FILES[@]}
    re='^[0-9]+$'
    i=0
    while [ $TOTAL -gt $i ]; do
	if [ $i -lt 0]; then
            i=0
	fi
        FILE=${FILES[$i]}
	MSG="Slide $(($i+1))/$TOTAL | b<Enter> Before | <Enter> Next | <ctrl+c> Quit"
        CONTENT=$(<$FILE)
        eval "echo \"${CONTENT//\"/\\\"}\"" | slide "$MSG"
        read -s ACTION < /dev/tty
	if [ -z $ACTION ]; then
            i=$(($i+1))
	else
            if [ $ACTION == "b" ]; then
                i=$(($i-1))
            elif [[ $ACTION =~ $re ]] ; then
                i=$(($ACTION-1))
            else
                i=$(($i+1))
            fi
	fi
    done
}
