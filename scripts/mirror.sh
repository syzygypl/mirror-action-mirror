#!/usr/bin/env bash

set -eux

export ROOT="$( cd "$( dirname ""${BASH_SOURCE[0]}"" )" >/dev/null && pwd )"

source "$ROOT/ssh.sh"
source "$ROOT/init_inputs.sh"
source "$ROOT/git.sh"

prepare_ssh
create_ssh_key "${ORIGIN_REPO_SSH_KEY}" "${ORIGIN_REPO_SSH_KEY_FILE}"
create_ssh_key "${MIRROR_REPO_SSH_KEY}" "${MIRROR_REPO_SSH_KEY_FILE}"
configure_ssh "${ORIGIN_REPO_HOST}" "${ORIGIN_REPO_SSH_KEY_FILE}"
configure_ssh "${MIRROR_REPO_HOST}" "${MIRROR_REPO_SSH_KEY_FILE}"
add_to_known_hosts "${ORIGIN_REPO_HOST}"
add_to_known_hosts "${MIRROR_REPO_HOST}"

ssh -vvv "git@${ORIGIN_REPO_HOST}"

clone "${ORIGIN_REPO_URL}" "${TMP_REPO_DIR}"
modify_git_config "${ORIGIN_REPO_USER}"
modify_repo_git_config "${TMP_REPO_DIR}"
push "${TMP_REPO_DIR}" "${MIRROR_REPO_URL}"
