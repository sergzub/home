#!/bin/bash -ue

IsVarSet()
{
    eval "[ \"\${${1}+isset}\" = 'isset' ]"
}

PrintHexCodes()
{
    local codes="${!1}" # is the same as: eval "local codes=\${${1}}"
    printf "readonly ${1}='"
    for((i=0;i<${#codes};i++)); do
        printf '\\x%02X' "'${codes:${i}:1}"
    done
    printf "'\n"
}

SetVarByTPut()
{
    # if eval "test -z \${$1:-}"; then # if variable is not set
        local var="$1"
        shift
        eval "readonly ${var}=\$(tput \"\$@\")"
    # fi

    PrintHexCodes "${var}"
}

SetVarBySetTerm()
{
    # if eval "test -z \${$1:-}"; then # if variable is not set
        local var="$1"
        shift
        eval "readonly ${var}=\$(setterm \"\$@\")"
    # fi

    PrintHexCodes "${var}"
}

SetColorVarCode()
{
    eval "readonly ${1}='${2}'"

    PrintHexCodes "${1}"
}

# --------------------------------------------
SetVarByTPut SGR0                sgr0

SetVarByTPut BLACK               setaf 0
SetVarByTPut RED                 setaf 1
SetVarByTPut GREEN               setaf 2
SetVarByTPut YELLOW              setaf 3
SetVarByTPut BLUE                setaf 4
SetVarByTPut MAGENTA             setaf 5
SetVarByTPut CYAN                setaf 6
SetVarByTPut WHITE               setaf 7
SetVarBySetTerm DEFAULT_FG      --foreground default

SetVarByTPut BLACK_BG            setab 0
SetVarByTPut RED_BG              setab 1
SetVarByTPut GREEN_BG            setab 2
SetVarByTPut YELLOW_BG           setab 3
SetVarByTPut BLUE_BG             setab 4
SetVarByTPut MAGENTA_BG          setab 5
SetVarByTPut CYAN_BG             setab 6
SetVarByTPut WHITE_BG            setab 7
SetVarBySetTerm DEFAULT_BG       --background default

SetVarBySetTerm TEXT_BOLD_ON     --bold on
SetVarBySetTerm TEXT_BOLD_OFF    --bold off

SetVarBySetTerm TEXT_BLINK_ON    --blink on
SetVarBySetTerm TEXT_BLINK_OFF   --blink off

# SetVarByTPut TEXT_REVERSE        rev

SetVarByTPut TEXT_STANDOUT_ON    smso
SetVarByTPut TEXT_STANDOUT_OFF   rmso

SetVarByTPut TEXT_UNDERLINED_ON  smul
SetVarByTPut TEXT_UNDERLINED_OFF rmul

# Commented below do not work in PuTTy at least

# SetVarByTPut TEXT_ITALIC_ON      sitm
# SetVarByTPut TEXT_ITALIC_OFF     ritm

# SetVarByTPut TEXT_DIM            dim
# SetVarByTPut TEXT_HIDDEN         invis
# SetVarByTPut TEXT_PROTECTED      prot

# SetVarByTPut TEXT_ALTERNATE_ON   smacs
# SetVarByTPut TEXT_ALTERNATE_OFF  rmacs

# --------------------------------------------
# 256 colors (works in PuTTY but no needed now)
#
# SetColorVarCode COLOR_GRAY          $'\x1B[38;5;8m'
# SetColorVarCode COLOR_GRAY_BG       $'\x1B[48;5;8m'

# --------------------------------------------
# Tests
#
echo "White: ${WHITE}white${SGR0}"
echo "Bright black: ${BLACK}${TEXT_BOLD_ON}gray${SGR0}"
echo "Bright green: ${GREEN}${TEXT_BOLD_ON}lime${SGR0}"
echo "Read: ${RED}red${SGR0}"
echo "Green BG: ${GREEN_BG}GREN_BG${SGR0}"
echo "Bold: ${TEXT_BOLD_ON}bold${SGR0}"
echo "Blink: ${TEXT_BLINK_ON}blink${SGR0}"
echo "Standout: ${TEXT_STANDOUT_ON}standout${TEXT_STANDOUT_OFF}"
echo "Standout+blue: ${BLUE}${TEXT_STANDOUT_ON}standout${TEXT_STANDOUT_OFF} text with blue${SGR0}"
echo "Underlined: '${TEXT_UNDERLINED_ON}underlined${TEXT_UNDERLINED_OFF}'"
# echo "Reverse video: ${TEXT_REVERSE}rev${SGR0}"

#echo "Italic: ${TEXT_ITALIC_ON}italic${TEXT_ITALIC_OFF}"
#echo "Hidden: '${TEXT_HIDDEN}Hidden${SGR0}'"
#echo "Dim: ${TEXT_DIM}dim${SGR0}"
#echo "Protected: '${TEXT_PROTECTED}protected${SGR0}'"
#echo "Alternate: ${TEXT_ALTERNATE_ON}alternate${TEXT_ALTERNATE_OFF}"


Out()
{
    local s="${1}"
    local out=''

    local useColors=true
    if [ ! -t 1 ] || IsVarSet NO_COLOR; then # || IsVarSet ANSI_COLORS_DISABLED
        useColors=false
    fi

    while :; do
        local suffix="${s#*<}"
        if [ ${#suffix} = ${#s} ]; then # '<' not found
            break
        fi

        local tag="${suffix%%>*}"
        if [ ${#tag} = ${#suffix} ]; then # '>' not found
            break
        fi

        local idxHead=0
        idxHead=$(( ${#suffix} + 1 ))
        out+="${s:0:-${idxHead}}"

        if ${useColors}; then
            case "${tag}" in
                'reset'|'/reset' ) out+="${SGR0}" ;;

                'black'   ) out+="${BLACK}"   ;;
                'red'     ) out+="${RED}"     ;;
                'green'   ) out+="${GREEN}"   ;;
                'yellow'  ) out+="${YELLOW}"  ;;
                'blue'    ) out+="${BLUE}"    ;;
                'magenta' ) out+="${MAGENTA}" ;;
                'cyan'    ) out+="${CYAN}"    ;;
                'white'   ) out+="${WHITE}"   ;;

                '/black'   ) out+="${DEFAULT_FG}" ;;
                '/red'     ) out+="${DEFAULT_FG}" ;;
                '/green'   ) out+="${DEFAULT_FG}" ;;
                '/yellow'  ) out+="${DEFAULT_FG}" ;;
                '/blue'    ) out+="${DEFAULT_FG}" ;;
                '/magenta' ) out+="${DEFAULT_FG}" ;;
                '/cyan'    ) out+="${DEFAULT_FG}" ;;
                '/white'   ) out+="${DEFAULT_FG}" ;;

                'black_bg'   ) out+="${BLACK_BG}"   ;;
                'red_bg'     ) out+="${RED_BG}"     ;;
                'green_bg'   ) out+="${GREEN_BG}"   ;;
                'yellow_bg'  ) out+="${YELLOW_BG}"  ;;
                'blue_bg'    ) out+="${BLUE_BG}"    ;;
                'magenta_bg' ) out+="${MAGENTA_BG}" ;;
                'cyan_bg'    ) out+="${CYAN_BG}"    ;;
                'white_bg'   ) out+="${WHITE_BG}"   ;;

                '/black_bg'   ) out+="${DEFAULT_BG}" ;;
                '/red_bg'     ) out+="${DEFAULT_BG}" ;;
                '/green_bg'   ) out+="${DEFAULT_BG}" ;;
                '/yellow_bg'  ) out+="${DEFAULT_BG}" ;;
                '/blue_bg'    ) out+="${DEFAULT_BG}" ;;
                '/magenta_bg' ) out+="${DEFAULT_BG}" ;;
                '/cyan_bg'    ) out+="${DEFAULT_BG}" ;;
                '/white_bg'   ) out+="${DEFAULT_BG}" ;;

                'b')  out+="${TEXT_BOLD_ON}"  ;;
                '/b') out+="${TEXT_BOLD_OFF}" ;;

                'blink')  out+="${TEXT_BLINK_ON}"  ;;
                '/blink') out+="${TEXT_BLINK_OFF}" ;;

                'u')  out+="${TEXT_UNDERLINED_ON}"  ;;
                '/u') out+="${TEXT_UNDERLINED_OFF}" ;;

                'so')  out+="${TEXT_STANDOUT_ON}"  ;;
                '/so') out+="${TEXT_STANDOUT_OFF}" ;;
            esac
        fi

        local idxTail=0
        idxTail=$(( ${#suffix} - ${#tag} - 1 ))
        if [ ${idxTail} -eq 0 ]; then # '>' is the latest char in the input string
            s=''
            break
        fi
        s="${s:(-${idxTail})}"
    done

    out+="${s}"

    out="${out//&lt;/<}" 
    out="${out//&gt;/>}" 
    out="${out//&amp;/&}" 

    printf '%b' "${out}"
}

OutIn()
{
    local s=''
    while IFS='' read -r s; do
        # Out "${s}"
        printf '%s' "$s"
    done
}

echo '---------------------------'
#Out "<u>Underline</u>\n"
Out "Begin <b>Bold</b> End\n"
Out "Begin<u> Underlined </u>End\n"
Out "Begin <green>Green text color</green> END\n"
Out "Begin <b><green>Bold+Green text color</green></b> END\n"
Out "Begin &lt;&amp;&gt; End\n"
#echo "Begin <u><cyan>Underlined cyan</cyan></u>End" | OutIn
# OutIn <<< "Begin <u><cyan>Underlined cyan</cyan></u> End\n"
OutIn << EOS
Begin <u><cyan>Underlined cyan</cyan></u> End

???

.
EOS
