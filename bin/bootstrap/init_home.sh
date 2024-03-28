#!/bin/bash -eux

Main()
{
    local MY_HOME_SSH_DIR="${HOME}/.ssh"

    # Check for files
    stat "id_rsa.pub"
    stat "github_id_rsa"

    mkdir -p "${MY_HOME_SSH_DIR}"
    chmod 700 "${MY_HOME_SSH_DIR}"

    cat "id_rsa.pub" >> "${MY_HOME_SSH_DIR}/authorized_keys"
    chmod 600 "${MY_HOME_SSH_DIR}/authorized_keys"
    rm "id_rsa.pub"

    chmod 600 "github_id_rsa"
    mv -i "github_id_rsa" "${MY_HOME_SSH_DIR}/"

    cat << HereDoc_SSH_CONFIG_APPEND >> "${MY_HOME_SSH_DIR}/config"
Host github.com
    PreferredAuthentications publickey
    IdentityFile /home/${USER}/.ssh/github_id_rsa
HereDoc_SSH_CONFIG_APPEND

    (umask 337 && sudo ${SHELL} -c "cat > /etc/sudoers.d/${USER}") << HereDoc_SUDOERSD_USER
${USER} ALL=NOPASSWD:ALL
Defaults:${USER} env_keep += "HOME"
Defaults:${USER} env_keep += "PATH"
HereDoc_SUDOERSD_USER

    # sudo apt install git vcsh
    # vcsh clone git@github.com:sergzub/home.git master

    # sudo apt install mc htop
}

Main "$@"
