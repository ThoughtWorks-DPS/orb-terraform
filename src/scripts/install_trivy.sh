#!/usr/bin/env bash

# download trivy package and verification packages
curl -SLO "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz"
curl -SLO "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz.pem"
curl -SLO "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz.sig"

# verify signature
if result=$(cosign verify-blob trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz --certificate trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz.pem --signature trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz.sig --certificate-identity-regexp 'https://github\.com/aquasecurity/trivy/\.github/workflows/.+' --certificate-oidc-issuer "https://token.actions.githubusercontent.com" 2>&1); then
    echo "Verified trivy installation package"
else
    echo "Unable to verify trivy installation package"
    echo "cosign Output:"
    echo "$result"
    exit 1
fi

# install and smoke test trivy
tar -xzf trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz
sudo mv trivy /usr/local/bin/trivy
trivy --version
