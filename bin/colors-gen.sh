#!/bin/bash -ue

PrintHexCodes()
{
    local codes="${!1}" # is the same as: eval "local codes=\${${1}}"
    printf "readonly ${1}=$'"
    for((i=0;i<${#codes};i++)); do
        printf '\\x%02X' "'${codes:${i}:1}"
    done
    printf "'\n"
}

SetColorVarTPut()
{
    # if eval "test -z \${$1:-}"; then # if variable is not set
        local var="$1"
        shift
        eval "readonly ${var}='$(tput "$@")'"
    # fi

    PrintHexCodes "${var}"
}

SetColorVarCode()
{
    eval "readonly ${1}='${2}'"

    PrintHexCodes "${1}"
}

# --------------------------------------------
SetColorVarTPut SGR0                sgr0

SetColorVarTPut BLACK               setaf 0
SetColorVarTPut RED                 setaf 1
SetColorVarTPut GREEN               setaf 2
SetColorVarTPut YELLOW              setaf 3
SetColorVarTPut BLUE                setaf 4
SetColorVarTPut MAGENTA             setaf 5
SetColorVarTPut CYAN                setaf 6
SetColorVarTPut WHITE               setaf 7

SetColorVarTPut BLACK_BG            setab 0
SetColorVarTPut RED_BG              setab 1
SetColorVarTPut GREEN_BG            setab 2
SetColorVarTPut YELLOW_BG           setab 3
SetColorVarTPut BLUE_BG             setab 4
SetColorVarTPut MAGENTA_BG          setab 5
SetColorVarTPut CYAN_BG             setab 6
SetColorVarTPut WHITE_BG            setab 7

SetColorVarTPut TEXT_BOLD           bold
SetColorVarTPut TEXT_BLINK          blink
SetColorVarTPut TEXT_REVERSE        rev

SetColorVarTPut TEXT_STANDOUT_ON    smso
SetColorVarTPut TEXT_STANDOUT_OFF   rmso

SetColorVarTPut TEXT_UNDERLINED_ON  smul
SetColorVarTPut TEXT_UNDERLINED_OFF rmul

# Commented below do not work in PuTTy at least

# SetColorVarTPut TEXT_DIM            dim
# SetColorVarTPut TEXT_HIDDEN         invis
# SetColorVarTPut TEXT_PROTECTED      prot

# SetColorVarTPut TEXT_ALTERNATE_ON   smacs
# SetColorVarTPut TEXT_ALTERNATE_OFF  rmacs

# SetColorVarTPut TEXT_ITALIC_ON      sitm
# SetColorVarTPut TEXT_ITALIC_OFF     ritm

# --------------------------------------------
# 256 colors (works in PuTTY but no needed now)
#
# SetColorVarCode COLOR_GRAY          $'\x1B[38;5;8m'
# SetColorVarCode COLOR_GRAY_BG       $'\x1B[48;5;8m'

# --------------------------------------------
# Tests
#
echo "Bright black: ${BLACK}${TEXT_BOLD}gray${SGR0}"
echo "Bright green: ${GREEN}${TEXT_BOLD}lime${SGR0}"
echo "Read: ${RED}red${SGR0}"
echo "Green BG: ${GREEN_BG}GREN_BG${SGR0}"
echo "Bold: ${TEXT_BOLD}bold${SGR0}"
echo "Blink: ${TEXT_BLINK}blink${SGR0}"
echo "Standout: ${TEXT_STANDOUT_ON}standout${TEXT_STANDOUT_OFF}"
echo "Standout+blue: ${BLUE}${TEXT_STANDOUT_ON}standout${TEXT_STANDOUT_OFF} text with blue${SGR0}"
echo "Underlined: '${TEXT_UNDERLINED_ON}underlined${TEXT_UNDERLINED_OFF}'"
echo "Reverse video: ${TEXT_REVERSE}rev${SGR0}"

#echo "Hidden: '${TEXT_HIDDEN}Hidden${SGR0}'"
#echo "Dim: ${TEXT_DIM}dim${SGR0}"
#echo "Protected: '${TEXT_PROTECTED}protected${SGR0}'"
#echo "Italic: ${TEXT_ITALIC_ON}italic${TEXT_ITALIC_OFF}"
#echo "Alternate: ${TEXT_ALTERNATE_ON}alternate${TEXT_ALTERNATE_OFF}"
