ORIGIN_SSH_KEY=`cat ./test-data/origin`
MIRROR_SSH_KEY=`cat ./test-data/mirror`

build:
	docker build -t syzygypl/mirror-action:latest .

run: build
	docker run \
	-e "INPUT_ORIGINSSHKEY=${ORIGIN_SSH_KEY}" \
	-e "INPUT_MIRRORSSHKEY=${MIRROR_SSH_KEY}" \
	-e "INPUT_MIRRORREPOURL=git@github.com:syzygypl/mirror-action.git" \
	-e "GITHUB_REPOSITORY=syzygypl/mirror-action" \
	syzygypl/mirror-action:latest

run-bash: build
	docker run \
	-e "INPUT_ORIGINSSHKEY=$(cat ./test-data/origin)" \
	-e "INPUT_MIRRORSSHKEY=$(cat ./test-data/mirror)" \
	-e "INPUT_MIRRORREPOURL=git@github.com:syzygypl/mirror-action.git" \
	-e "GITHUB_REPOSITORY=git@github.com:syzygypl/mirror-action.git" \
	-it --entrypoint="/bin/bash" \
	syzygypl/mirror-action:latest
