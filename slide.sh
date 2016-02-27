#!/bin/bash

let CURRENTPAGE=0
let TOTALSLIDES=$(grep "<<EOF" slideshow.sh | wc -l | tr -d " ")
echo "Use \"source ./slide.sh\" on the top of your shell slidedeck to use this!"
function slide() {
    clear
    local -r TPUT=$(type -p tput)
    [ -x "$TPUT" ] || exit 1
    local -r COLORS=(red=31 green=32 yellow=33 blue=34 purple=35 cyan=36 end=)
    local -ri COLS=$($TPUT cols) ROWS=$($TPUT lines)
    local -i CENTER=0 LINENUM=0 CTRPOS=0 MSGPOS=0 HASCOLOR=1
    local LINE='' BARE=''
    trap "$TPUT clear" 0
    let CURRENTPAGE++
    printf " Loading slide [$CURRENTPAGE/$TOTALSLIDES] "
spinner &
sleep .5
kill "$!"
wait $! 2>/dev/null
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
        [ ${#BARE} -le $COLS ] && CTRPOS=$(((COLS-${#BARE})/2))
        [ $CENTER -eq 1 ] && $TPUT cup $LINENUM $CTRPOS || $TPUT cup $LINENUM 0
        printf -- "${LINE//%/%%}\n"
        sleep .1
        $TPUT cup $ROWS $COLS && let LINENUM++
        [ ${#BARE} -gt $COLS ] && let LINENUM++
    done
    $TPUT cup $ROWS $MSGPOS && echo -n "Slide: $CURRENTPAGE/$TOTALSLIDES || "$(echo "scale = 2; $CURRENTPAGE/$TOTALSLIDES*100" | bc)%
    read -s < /dev/tty
}

spinner() {
    local i sp n
    sp='/-\|'
    n=${#sp}
    printf ' '
    while sleep 0.1; do
        printf "%s\b" "${sp:i++%n:1}"
    done
    PAGE++
}
