#!/usr/bin/env bash
set -eo pipefail

# as a pip package, minimal verification is possible
sudo pip install --no-cache-dir --break-system-packages checkov=="${CHECKOV_VERSION}"
checkov --version
