#!/usr/bin/env bash

# download snyk and verification packages
SNYK_SIGNING_KEY=A22665FB96CAB0E0973604C83676C4B8289C296E
SNYK_PACKAGE_NAME=$(cat /etc/os-release | grep -q alpine && echo "snyk-alpine" || echo "snyk-linux")
curl -sSLO "https://static.snyk.io/cli/v${SNYK_VERSION}/${SNYK_PACKAGE_NAME}"
curl -sSLO "https://static.snyk.io/cli/v${SNYK_VERSION}/sha256sums.txt.asc"
grep "${SNYK_PACKAGE_NAME}" < sha256sums.txt.asc > checksums.txt
gpg --keyserver hkps://keys.openpgp.org --recv-keys "${SNYK_SIGNING_KEY}"

# verify snyk package sha
if result=$(shasum --ignore-missing --algorithm 256 --check  checksums.txt 2>&1); then
    echo "Verified snyk package sha"
else
    echo "Unable to verify snyk package sha"
    echo "shasum Output:"
    echo "$result"
    exit 1
fi

# verify signature
if result=$(gpg --verify sha256sums.txt.asc  2>&1); then
    echo "Verified signature"
else
    echo "Unable to verify signature"
    echo "GPG Output:"
    echo "$result"
    exit 1
fi

# install and smoke test snyk
chmod +x "${SNYK_PACKAGE_NAME}"
sudo mv "${SNYK_PACKAGE_NAME}" /usr/local/bin/snyk
