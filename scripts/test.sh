#!/usr/bin/env bash

#!/usr/bin/env bash

set -eux

CLONED_REPO_DIR="/tmp/repo/${GITHUB_SHA}"
REPO_HOST="github.com"
REPO_USER="git"
REPO_URL="${REPO_USER}@${REPO_HOST}:${GITHUB_REPOSITORY}.git"
CRED_HELPER="${GITHUB_WORKSPACE}/.github/workflows/cred-helper.sh"

chmod +x ${CRED_HELPER}

KNOWN_HOSTS_FILE="${HOME}/.ssh/known_hosts"
KNOWN_HOSTS_DIR="$(dirname $KNOWN_HOSTS_FILE)"
SSH_CONFIG="${HOME}/.ssh/config"
SSH_KEY="${HOME}/.ssh/github"
MIRROR_SSH_KEY="${HOME}/.ssh/mirror"

mkdir -p "${KNOWN_HOSTS_DIR}"
touch "${KNOWN_HOSTS_FILE}"
echo "${SSH_PRIVATE_KEY}" > ${SSH_KEY}
echo "${MIRROR_SSH_PRIVATE_KEY}" > ${MIRROR_SSH_KEY}
chmod 700 "${KNOWN_HOSTS_DIR}"
chmod 600 "${KNOWN_HOSTS_FILE}"
chmod 600 "${SSH_KEY}"
chmod 600 "${MIRROR_SSH_KEY}"

touch "${SSH_CONFIG}"
echo "Host ${REPO_HOST}\n" >> ${SSH_CONFIG}
echo " IdentitiesOnly yes\n" >> ${SSH_CONFIG}
echo " UserKnownHostsFile=/dev/null\n" >> ${SSH_CONFIG}
echo " StrictHostKeyChecking no\n" >> ${SSH_CONFIG}
echo " IdentityFile ~/.ssh/github\n" >> ${SSH_CONFIG}

echo "Host ${MIRROR_REPO_HOST}\n" >> ${SSH_CONFIG}
echo " IdentitiesOnly yes\n" >> ${SSH_CONFIG}
echo " UserKnownHostsFile=/dev/null\n" >> ${SSH_CONFIG}
echo " StrictHostKeyChecking no\n" >> ${SSH_CONFIG}
echo " IdentityFile ~/.ssh/mirror" >> ${SSH_CONFIG}

ssh-keyscan -t rsa "$REPO_HOST" >> "${KNOWN_HOSTS_FILE}"

git config --global credential.username "${GIT_USERNAME}"
git config --global core.askPass "${CRED_HELPER}"
git config --global credential.helper cache

mkdir -p "${CLONED_REPO_DIR}"

git clone --mirror "$REPO_URL" "$CLONED_REPO_DIR/.git"

cd "$CLONED_REPO_DIR"
FILE="./.git/config"
OUTPUT="./.git/config"
line=$(grep -n "fetch = +refsasdasd/\*:refs/\*" ${FILE} | cut -d : -f 1)

if [[ ${line} = "" ]]; then
    exit 10
fi
cat ${FILE} | sed "${line}s|.*|	fetch = +refs/heads/\*\:refs/heads/\*\\|	fetch \= +refs/tags/\*\:refs/tags/\*|" | tr '|' '\n' > ${OUTPUT}

git remote update
git config --bool core.bare false
git push --mirror "$MIRROR_REPO" | true
