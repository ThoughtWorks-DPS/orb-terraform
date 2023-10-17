#!/usr/bin/env bash

# download and import HashiCorp public key
curl --remote-name https://keybase.io/hashicorp/pgp_keys.asc
result=$(gpg --import pgp_keys.asc 2>&1)

if [ $? -eq 0 ]; then
    echo "loaded HashiCorp public key"
else
    echo "Unable to import HashiCorp key"
    echo "GPG Output:"
    echo "$result"
fi

# download terraform installation package, SHA checksum and signatures
curl --remote-name https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
curl --remote-name https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS
curl --remote-name https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig

# verify SHA signature
result=$(gpg --verify terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig terraform_${TERRAFORM_VERSION}_SHA256SUMS 2>&1)

if [ $? -eq 0 ]; then
    echo "Verified SHA signature"
else
    echo "Unable to verify SHA signature"
    echo "GPG Output:"
    echo "$result"
    exit 1
fi

# verify terraform cli download
result=$(shasum --ignore-missing --algorithm 256 --check terraform_${TERRAFORM_VERSION}_SHA256SUMS 2>&1)

if [ $? -eq 0 ]; then
    echo "Verified terraform package"
else
    echo "Unable to terraform package"
    echo "shasum Output:"
    echo "$result"
    exit 1
fi

sudo unzip -o "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d /usr/local/bin
terraform version
