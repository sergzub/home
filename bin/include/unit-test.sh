#!/bin/bash -ue

. 'include-shh'

Include 'utils'

readonly THIS_PATH="$(readlink -e "$(dirname "$0")")"
readonly UNIT_TEST_PATH="${THIS_PATH}/unit-test"

readonly COLUMNS_NUM="${COLUMNS:-75}"
readonly LEFT_IDENT='  '

TOTAL_RESULT=0

PrintTestResult()
{
    local tstDescr="${1}"
    local res="${2}"

    local dotLen="$(( ${COLUMNS_NUM} - ${#LEFT_IDENT} - 3 - ${#tstDescr} - 6 ))"
    local dotFiller=''
    RepeatToVar "${dotLen}" '.' @dotFiller

    # ●
    Out "${LEFT_IDENT} * ${tstDescr}<b><black>${dotFiller}</b></black>"

    if [ "${res}" -eq 0 ]; then
        Out '[ <green>OK</green> ]\n'
    else
        Out '[<b><red>FAIL</red></b>]\n'
        TOTAL_RESULT=1
    fi
}

ExecTest()
{
    local tstDescr="${1}"
    local expectedCond="${2}"

    local outTxt=''
    local res=0

    if ${expectedCond}; then
        outTxt="$(UnitTest 2>&1)" || res=1
    else
        ! outTxt="$(UnitTest 2>&1)" || res=1
    fi

    PrintTestResult "${tstDescr}" "${res}"

    if [ "${res}" -ne 0 ]; then
        TOTAL_RESULT=1
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

    # if [ $# -gt 0 ]; then
    # else
    # fi

    local allTests="$(find "${UNIT_TEST_PATH}" -type f -name '*.test' -printf '%P\n')"
    for tst in ${allTests}; do
        printf '%b' "${tst}\n"
        ( . "${UNIT_TEST_PATH}/${tst}" ; exit ${TOTAL_RESULT} ) || TOTAL_RESULT=$?
    done

    if [ "${TOTAL_RESULT}" -ne 0 ]; then
        Die "Tests failed"
    fi
}

Main "$@"
