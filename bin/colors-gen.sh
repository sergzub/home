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

# Commented do not work in PuTTy at least

SetColorVarTPut COLOR_RESET         sgr0
SetColorVarTPut TEXT_RESET          sgr0

SetColorVarTPut COLOR_BLACK         setaf 0
SetColorVarTPut COLOR_RED           setaf 1
SetColorVarTPut COLOR_GREEN         setaf 2
SetColorVarTPut COLOR_YELLOW        setaf 3
SetColorVarTPut COLOR_BLUE          setaf 4
SetColorVarTPut COLOR_MAGENTA       setaf 5
SetColorVarTPut COLOR_CYAN          setaf 6
SetColorVarTPut COLOR_WHITE         setaf 7

SetColorVarTPut COLOR_BLACK_BG      setab 0
SetColorVarTPut COLOR_RED_BG        setab 1
SetColorVarTPut COLOR_GREEN_BG      setab 2
SetColorVarTPut COLOR_YELLOW_BG     setab 3
SetColorVarTPut COLOR_BLUE_BG       setab 4
SetColorVarTPut COLOR_MAGENTA_BG    setab 5
SetColorVarTPut COLOR_CYAN_BG       setab 6
SetColorVarTPut COLOR_WHITE_BG      setab 7

SetColorVarTPut TEXT_BOLD           bold
# SetColorVarTPut TEXT_DIM            dim
SetColorVarTPut TEXT_BLINK          blink
SetColorVarTPut TEXT_REV            rev
# SetColorVarTPut TEXT_HIDDEN         invis
# SetColorVarTPut TEXT_PROTECTED      prot

SetColorVarTPut TEXT_STANDOUT_ON    smso
SetColorVarTPut TEXT_STANDOUT_OFF   rmso

SetColorVarTPut TEXT_UNDERLINED_ON  smul
SetColorVarTPut TEXT_UNDERLINED_OFF rmul

# SetColorVarTPut TEXT_ALTERNATE_ON   smacs
# SetColorVarTPut TEXT_ALTERNATE_OFF  rmacs

# SetColorVarTPut TEXT_ITALIC_ON      sitm
# SetColorVarTPut TEXT_ITALIC_OFF     ritm

# ----------------------- --------------------
# # 256 colors (works in PuTTY but no needed now)
# SetColorVarCode COLOR_GRAY          $'\x1B[38;5;8m'
# SetColorVarCode COLOR_GRAY_BG       $'\x1B[48;5;8m'

# ----------------- Tests --------------------
echo "Bright black: ${COLOR_BLACK}${TEXT_BOLD}gray${COLOR_RESET}"
echo "Bright green: ${COLOR_GREEN}${TEXT_BOLD}lime${TEXT_RESET}"
echo "Read: ${COLOR_RED}red${COLOR_RESET}"
echo "Green BG: ${COLOR_GREEN_BG}GREN_BG${COLOR_RESET}"
echo "Bold: ${TEXT_BOLD}bold${TEXT_RESET}"
echo "Blink: ${TEXT_BLINK}blink${TEXT_RESET}"
echo "Standout: ${TEXT_STANDOUT_ON}standout${TEXT_STANDOUT_OFF}"
echo "Standout+blue: ${COLOR_BLUE}${TEXT_STANDOUT_ON}standout${TEXT_STANDOUT_OFF} text with blue${TEXT_RESET}"
echo "Underlined: '${TEXT_UNDERLINED_ON}underlined${TEXT_UNDERLINED_OFF}'"
echo "Reverse video: ${TEXT_REV}rev${TEXT_RESET}"

#echo "Hidden: '${TEXT_HIDDEN}Hidden${TEXT_RESET}'"
#echo "Dim: ${TEXT_DIM}dim${TEXT_RESET}"
#echo "Protected: '${TEXT_PROTECTED}protected${TEXT_RESET}'"
#echo "Italic: ${TEXT_ITALIC_ON}italic${TEXT_ITALIC_OFF}"
#echo "Alternate: ${TEXT_ALTERNATE_ON}alternate${TEXT_ALTERNATE_OFF}"
