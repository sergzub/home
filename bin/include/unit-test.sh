#!/bin/bash -ue

. 'include-shh'

Include 'path'
Include 'utils'

readonly THIS_PATH="$(readlink -e "$(dirname "$0")")"
readonly UNIT_TEST_PATH="${THIS_PATH}/unit-test"

readonly COLUMNS_NUM="${COLUMNS:-75}"
readonly LEFT_IDENT='  '

TOTAL_COUNT=0
FAIL_COUNT=0

PrintTestResult()
{
    local tstDescr="${1}"
    local res="${2}"

    local dotLen="$(( ${COLUMNS_NUM} - ${#LEFT_IDENT} - 3 - ${#tstDescr} - 6 ))"
    local dotFiller=''
    RepeatToVar "${dotLen}" '.' @dotFiller

    # ●
    local markSign=''
    local okFail=''

    if [ "${res}" -eq 0 ]; then
        markSign='+'
        okFail=' <green>OK</green> '
    else
        markSign='-'
        okFail='<b><red>FAIL</red></b>'
    fi

    Out "${LEFT_IDENT} ${markSign} ${tstDescr}<b><black>${dotFiller}</b></black>[${okFail}]\n"
}

ExecTest()
{
    local tstDescr="${1}"
    local expectedCond="${2}"

    local outTxt=''
    local res=0

    if ${expectedCond}; then
        outTxt="$(UnitTest 2>&1)" || res=$?
    else
        outTxt="$(UnitTest 2>&1)" && res=1
    fi

    ((++TOTAL_COUNT))

    PrintTestResult "${tstDescr}" "${res}"

    if [ "${res}" -ne 0 ]; then
        ((++FAIL_COUNT))
        if [ "${#outTxt}" -ne 0 ]; then
            Out "<b><red>${outTxt}</red></b>\n"
        fi
    fi
}

Test_OK()
{
    ExecTest "${1}" true
}

Test_FAIL()
{
    ExecTest "${1}" false
}

Main()
{
    if [ ! -d "${UNIT_TEST_PATH}" ]; then
        Die "'${UNIT_TEST_PATH}' path not found"
    fi

    local tstFilter=()
    if [ $# -eq 0 ]; then
        tstFilter+=('-name' '*.test')
    else
        tstFilter+=('-false')
        local arg=''
        for arg in "$@"; do
            if ContainsForwardSlash "${arg}"; then
                if [ "${arg##./}" != './' ]; then
                    arg="./${arg}"
                fi
                tstFilter+=('-o' '-path' "${arg}")
            else
                tstFilter+=('-o' '-name' "${arg}")
            fi
        done
    fi

    local allTests=''
    allTests="$(cd "${UNIT_TEST_PATH}" && find . -warn -type f \( "${tstFilter[@]}" \) -printf '%P\n' | sort | uniq)"
    for tst in ${allTests}; do
        Out "<yellow>${tst}</yellow>\n"
        local tstStats=''
        tstStats=$(TOTAL_COUNT=0; FAIL_COUNT=0; . "${UNIT_TEST_PATH}/${tst}" 1>&2 && printf '%d,%d\n' "${TOTAL_COUNT}" "${FAIL_COUNT}")
        TOTAL_COUNT="$((TOTAL_COUNT + "${tstStats%%,*}"))"
        FAIL_COUNT="$((FAIL_COUNT + "${tstStats##*,}"))"
        Echo
    done

    OutFmt "Total: %2d\nFail : %2d\n" "${TOTAL_COUNT}" "${FAIL_COUNT}"

    if [ "${FAIL_COUNT}" -gt 0 ]; then
        Die "Tests failed"
    else
        Echo
    fi
}

Main "$@"
