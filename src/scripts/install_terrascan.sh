#!/usr/bin/env bash
set -eo pipefail

# download terrascan and verification packages
curl -SLO "https://github.com/tenable/terrascan/releases/download/v${TERRASCAN_VERSION}/checksums.txt"
curl -SLO "https://github.com/tenable/terrascan/releases/download/v${TERRASCAN_VERSION}/terrascan_${TERRASCAN_VERSION}_Linux_x86_64.tar.gz"

# verify terrascan package sha
if result=$(shasum --ignore-missing --algorithm 256 --check  checksums.txt 2>&1); then
    echo "Verified terrascan package sha"
else
    echo "Unable to verify terrascan package sha"
    echo "shasum Output:"
    echo "$result"
    exit 1
fi

# install and smoke test terrascan
sudo tar -xf "terrascan_${TERRASCAN_VERSION}_Linux_x86_64.tar.gz" terrascan
sudo mv terrascan /usr/local/bin/terrascan
terrascan version
