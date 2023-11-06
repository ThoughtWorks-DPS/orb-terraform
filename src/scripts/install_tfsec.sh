#!/usr/bin/env bash
set -eo pipefail

# load tfsec and verification packages
curl -SLO "https://github.com/aquasecurity/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64"
curl -SLO "https://github.com/aquasecurity/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64.D66B222A3EA4C25D5D1A097FC34ACEFB46EC39CE.sig"
curl -SLO "https://github.com/aquasecurity/tfsec/releases/download/v${TFSEC_VERSION}/tfsec_checksums.txt"
grep tfsec-linux-amd64 < tfsec_checksums.txt > checksums.txt

cat <<EOF > tfsec.key
-----BEGIN PGP PUBLIC KEY BLOCK-----

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
nX5QmAEwF/nBYV3Du7TIvHtz91yL8A==
=opqY
-----END PGP PUBLIC KEY BLOCK-----
EOF

# import public key
if result=$(gpg --import tfsec.key 2>&1); then
  echo "loaded aquasec/tfsec public key"
else
    echo "Unable to import aquasec/tfsec public key"
    echo "GPG Output:"
    echo "$result"
fi

# verify tfsec package signature
if result=$(gpg --verify tfsec-linux-amd64.D66B222A3EA4C25D5D1A097FC34ACEFB46EC39CE.sig tfsec-linux-amd64 2>&1); then
    echo "Verified SHA signature"
else
    echo "Unable to verify SHA signature"
    echo "GPG Output:"
    echo "$result"
    exit 1
fi

# verify tfsec package sha
if result=$(shasum --ignore-missing --algorithm 256 --check  checksums.txt 2>&1); then
    echo "Verified tfsec package sha"
else
    echo "Unable to verify tfsec build source"
    echo "shasum Output:"
    echo "$result"
    exit 1
fi

# install and smoke test tfsec
sudo mv tfsec-linux-amd64 tfsec
sudo chmod +x tfsec
sudo mv tfsec /usr/local/bin/tfsec
tfsec --version
