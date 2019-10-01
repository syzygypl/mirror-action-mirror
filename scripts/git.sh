#!/usr/bin/env bash

function clone(){
    local repo="$1"
    local dest="$2/.git"
    mkdir -p "${dest}"
    git clone --mirror "${repo}" "${dest}"
}


function modify_git_config(){
    local username="$1"
    git config --global core.sshCommand "ssh -vvv"
    git config --global credential.username "${username}"
    git config --global credential.helper cache
}

function modify_repo_git_config(){
    local repo="$1"
    local file="$repo/.git/config"

    line=$(grep -n "fetch = +refs/\*:refs/\*" ${file} | cut -d : -f 1)

    if [[ ${line} = "" ]]; then
        echo "Cannot change git fetch refs in catalog ${repo}"
        exit 20
    fi
    cat ${file} | sed "${line}s|.*|	fetch = +refs/heads/\*\:refs/heads/\*\\|	fetch \= +refs/tags/\*\:refs/tags/\*|" | tr '|' '\n' > ${file}

    cd ${repo} && git remote update
    cd ${repo} && git config --bool core.bare false
}

function push() {
    local repo="$1"
    local remote="$2"

    cd "${repo}" && git push --mirror "$remote" | true
}

