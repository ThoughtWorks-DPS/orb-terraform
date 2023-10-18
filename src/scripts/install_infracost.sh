#!/usr/bin/env bash

# download infracost and verification packages
curl -SLO "https://github.com/infracost/infracost/releases/download/v${INFRACOST_VERSION}/infracost-linux-amd64.tar.gz"
curl -SLO "https://github.com/infracost/infracost/releases/download/v${INFRACOST_VERSION}/infracost-linux-amd64.tar.gz.sha256"

# verify package sha
if result=$(shasum --ignore-missing --algorithm 256 --check infracost-linux-amd64.tar.gz.sha256 2>&1); then
    echo "Verified infracost package sha"
else
    echo "Unable to verify infracost package sha"
    echo "shasum Output:"
    echo "$result"
    exit 1
fi

# install and smoke test infracost
sudo tar -xf infracost-linux-amd64.tar.gz
sudo mv infracost-linux-amd64 /usr/local/bin/infracost
infracost --version
