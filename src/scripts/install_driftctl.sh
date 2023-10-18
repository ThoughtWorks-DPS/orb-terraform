#!/usr/bin/env bash

# download driftctl and verification packages
curl -SLO "https://github.com/snyk/driftctl/releases/download/v${DRIFTCTL_VERSION}/driftctl_linux_amd64"
curl -SLO "https://github.com/snyk/driftctl/releases/download/v${DRIFTCTL_VERSION}/driftctl_SHA256SUMS"
curl -SLO "https://github.com/snyk/driftctl/releases/download/v${DRIFTCTL_VERSION}/driftctl_SHA256SUMS.gpg"
gpg --keyserver hkps://keys.openpgp.org --recv-keys 65DDA08AA1605FC8211FC928FFB5FCAFD223D274

# verify package signature
if result=$(gpg --verify driftctl_SHA256SUMS.gpg driftctl_SHA256SUMS 2>&1); then
    echo "Verified driftctl signature"
else
    echo "Unable to verify driftctl signature"
    echo "shasum Output:"
    echo "$result"
    exit 1
fi

# verify package sha
if result=$(shasum --ignore-missing --algorithm 256 --check driftctl_SHA256SUMS 2>&1); then
    echo "Verified driftctl package sha"
else
    echo "Unable to verify driftctl package sha"
    echo "shasum Output:"
    echo "$result"
    exit 1
fi

sudo chmod +x driftctl_linux_amd64
sudo mv driftctl_linux_amd64 /usr/local/bin/driftctl
driftctl version
