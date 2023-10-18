#!/usr/bin/env bash

# download tflint package and verification packages
curl -SLO "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip"
curl -SLO "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/checksums.txt"
curl -SLO "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/checksums.txt.pem"
curl -SLO "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/checksums.txt.keyless.sig"

# verify cosign orignation
if result=$(cosign verify-blob --certificate=checksums.txt.pem --signature=checksums.txt.keyless.sig --certificate-identity-regexp="^https://github.com/terraform-linters/tflint" --certificate-oidc-issuer=https://token.actions.githubusercontent.com checksums.txt 2>&1); then
    echo "Verified cosign build source"
else
    echo "Unable to verify cosign build source"
    echo "cosign Output:"
    echo "$result"
    exit 1
fi

# verify cosign package sha
if result=$(shasum --ignore-missing --algorithm 256 --check  checksums.txt 2>&1); then
    echo "Verified cosign package sha"
else
    echo "Unable to verify cosign build source"
    echo "shasum Output:"
    echo "$result"
    exit 1
fi

# install and smoke test tflint
sudo unzip -o tflint_linux_amd64.zip -d /usr/local/bin
tflint --version
