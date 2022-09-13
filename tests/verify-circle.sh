#!/bin/bash -e

DEPLOY_SUFFIX="${VIP_DEPLOY_SUFFIX:--built}"
DEPLOY_BRANCH="${CIRCLE_BRANCH}${DEPLOY_SUFFIX}"
REPO_SLUG="${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}"
REPO_SSH_URL="git@github.com:${REPO_SLUG}"
VERIFY_DIR="/tmp/vip-go-build-verify-$(date +%s)"

if [[ -d "$VERIFY_DIR" ]]; then
	echo "ERROR: ${VERIFY_DIR} already exists."
	echo "This should not happen, and something is probably broken!"
	exit 1
fi

echo "Verifying built branch: ${DEPLOY_BRANCH} for ${REPO_SSH_URL} in ${VERIFY_DIR}"

git clone --depth 1 --single-branch --branch "${DEPLOY_BRANCH}" "${REPO_SSH_URL}" "${VERIFY_DIR}"

cd "${VERIFY_DIR}"

echo ""
echo "## Running some tests"
echo ""

README_FILE="build/README.md"
if [ ! -f "${README_FILE}" ]; then
	echo "- Generated file (${README_FILE}) was not found; something is broken!": exit 1
else
	echo "- ${README_FILE} looks good!"
fi

echo ""

SKIPPED_FILE="fixtures/skip-this-file.txt"
if [ -f "${SKIPPED_FILE}" ]; then
	echo "- Found file (${SKIPPED_FILE}) that should have been ignored; something is broken!"; exit 1
else
	echo "- ${SKIPPED_FILE} looks good!"
fi
