#!/bin/bash -e
#
# Prepare to deploy your branch from Travis
#

if [[ -z "${BUILT_BRANCH_DEPLOY_KEY}" ]]; then
	echo "ERROR: BUILT_BRANCH_DEPLOY_KEY not defined; ending build!"
	echo "This variable needs to contain the deploy key for your machine user. Please see `ci/README.md` for how to create and set this key."
	exit 1
fi

# Keep the key out of the build log for security
set +x

# Nuke the existing SSH key
rm -fv ~/.ssh/id_rsa

# See ci/README.md for how to create and set this key
echo -e ${BUILT_BRANCH_DEPLOY_KEY} > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

# Restore script echoing now we've done the private things
set -x

curl -s "https://raw.githubusercontent.com/Automattic/vip-go-build/master/known_hosts" >> ~/.ssh/known_hosts
