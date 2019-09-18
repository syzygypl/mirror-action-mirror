#!/usr/bin/env bash


function explode_mirror_repo(){
    local repo=$1
    match="^(ssh:\/\/)?((\w+)@?)?([a-zA-Z0-9\._-]+)(:[0-9]{1,5}+)?(\/|:)?([a-zA-Z\.\/_-]+).git$"

    if [[ $(echo $repo | sed -nr "/${match}/p") = '' ]]; then
        echo "Mirror repo value: $repo cannot match (ssh://)?(user@)?(domain)(:port)?(/|:)?(path).git pattern"
        echo "Some examples are:"
        echo "* git@github.com:syzygypl/mirror-action.git"
        echo "* ssh://git@git.domain.pl:4422/syzygypl/mirror-action.git"
        exit 32;
    fi

    MIRROR_REPO_USER=$(echo $repo | sed -nr "s/${match}/\3/p")
    MIRROR_REPO_HOST=$(echo $repo | sed -nr "s/${match}/\4/p")
}


function get_input(){
    local name="$1"
    local input_prefix="INPUT_"
    local var_name_part=$(printf '%s\n' "$name" | awk '{ print toupper($0) }')
    local var_name="${input_prefix}${var_name_part}"
    local var_value=$(eval "echo \"\$${var_name}\"")
    if [[ "${var_value}" = "" ]]; then
        echo "Variable ${name} with env var name $var_name is not defined"
        echo "Please consider checking:"
        echo "* Have you used \`with:\` yaml block with proper map parameter \`${name}\` "
        echo "* Have you used right secret variable - the proper syntax \${{ secrets.{name} }}"
        exit 30;
    fi
    echo "${var_value}"
}

function check_ssh_key_content(){
    local key="$1"
    echo "$key" | tr -d '\n\r' | grep -Pz '^-----BEGIN ([A-Z ]+) PRIVATE KEY-----[\w\W]*-----END ([A-Z ]+) PRIVATE KEY-----$'
    if [[ "$?" != "0" ]]; then
        echo "Key ${key} is not valid it should have format: "
        echo "-----BEGIN {CRYPT} PRIVATE KEY-----"
        echo "***********************************"
        echo "***********************************"
        echo "-----END {CRYPT} PRIVATE KEY-----"
        exit 31;
    fi
}

USER=$(whoami)
HOME=$(eval echo "~$USER")

ORIGIN_REPO_HOST="github.com"
ORIGIN_REPO_USER="git"
ORIGIN_REPO_URL="${ORIGIN_REPO_USER}@${ORIGIN_REPO_HOST}:${GITHUB_REPOSITORY}.git"

ORIGIN_REPO_SSH_KEY=$(get_input originSshKey)
MIRROR_REPO_SSH_KEY=$(get_input mirrorSshKey)
MIRROR_REPO_SSH_KEY_FILE="$(mktemp -p "/tmp")"
ORIGIN_REPO_SSH_KEY_FILE="$(mktemp -p "/tmp")"

TMP_REPO_DIR=$(mktemp -d -p "/tmp")

MIRROR_REPO_URL=$(get_input mirrorRepoUrl)
explode_mirror_repo "${MIRROR_REPO_URL}"
check_ssh_key_content "${ORIGIN_REPO_SSH_KEY}"
check_ssh_key_content "${MIRROR_REPO_SSH_KEY}"
