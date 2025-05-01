#!/bin/sh

set -ex

DEPLOY_SUFFIX="${VIP_DEPLOY_SUFFIX:--built}"
DEPLOY_BRANCH="${GITHUB_REF_NAME}${DEPLOY_SUFFIX}"
REPO_CLONE_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}"
VERIFY_DIR="/tmp/vip-go-build-verify-$(date +%s)"

if [ -d "$VERIFY_DIR" ]; then
	echo "ERROR: ${VERIFY_DIR} already exists."
	echo "This should not happen; something is probably broken!"
	exit 1
fi

echo "Verifying built branch: ${DEPLOY_BRANCH} for ${REPO_CLONE_URL} in ${VERIFY_DIR}"

git clone --depth 1 --single-branch --branch "${DEPLOY_BRANCH}" "${REPO_CLONE_URL}" "${VERIFY_DIR}"

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
