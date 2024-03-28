#!/bin/bash -eu

UncommentAlias()
{
    local a="${1}"
    local bashrc="${HOME}/.bashrc_tst"

    sed -i "s|#alias ${a}|alias ${a}|" ${bashrc} || true
}

FixPathEnvVar()
{
    :
}

Main()
{
    UncommentAlias 'grep'
    UncommentAlias 'fgrep'
    UncommentAlias 'egrep'

    UncommentAlias 'll'
    UncommentAlias 'la'
    UncommentAlias 'l'

    FixPathEnvVar
}

Main "$@"
