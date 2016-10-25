#!/bin/bash
function slide() {
    local -r TPUT=$(type -p tput || kill -9 $$)
    local -r IFS='' MESSAGE=${1:-↲ Next | ^c Quit}
    local -r COLORS=(red=31 green=32 yellow=33 blue=34 purple=35 cyan=36 end=)
    local -ri COLS=$($TPUT cols) ROWS=$($TPUT lines)
    local -i CENTER=0 LINENUM=0 CTRPOS=0 MSGPOS=0 HASCOLOR=1
    local LINE='' BARE=''
    trap "$TPUT clear" 0
    $TPUT clear
    while read LINE && BARE=$LINE; do
        [ "$LINE" == '!!color' ] && HASCOLOR=1 && continue
        [ "$LINE" == '!!nocolor' ] && HASCOLOR=0 && continue
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
    for ((GOTO=0;;${GOTO:=0})); do
        $TPUT cup $ROWS 0 && printf "%${MSGPOS}s\033[0m%s" " " $MESSAGE
        [ ${GOTO} -gt 0 ] && $TPUT cup $ROWS 0 && printf "\033[0mJump: ${GOTO}"
        read -s -n 1 CHAR < /dev/tty
        case $CHAR in
            $'\033') GOTO=0                                          ;;
            $'\177') [ $GOTO -eq 0 ] && return 255 || GOTO=${GOTO%?} ;;
            [0-9]*)  [ $GOTO -eq 0 ] && GOTO=$CHAR || GOTO+=$CHAR    ;;
            *)       [ $GOTO -gt 254 ] && return 254 || return $GOTO ;;
        esac
    done
}

function deck() {
    local -ra FILES=($1/*.slide)
    local -ri TOTAL=$((${#FILES[@]}>254?254:${#FILES[@]}))
    for ((i=1;;i=$((i>TOTAL?TOTAL:(i<1?1:i))))); do
        CONTENT=$(<${FILES[$((i-1))]})
        MSG="Slide ${i}/${TOTAL} | ↲ Next | ← Back | 1..${TOTAL} Jump | ^c Quit"
        eval "echo \"${CONTENT//\"/\\\"}\"" | slide "$MSG"
        i=$(($?==255?(i-1):($?==0?i+1:$?)))
    done
}
