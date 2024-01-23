#!/usr/bin/env bash
set -eo pipefail

if [[ ! -f ".tflint.hcl" ]]; then
  export ver=$(curl  "https://api.github.com/repos/terraform-linters/tflint-ruleset-$PROVIDER/tags" | jq -r '.[0].name' | grep -Eo '[0-9]\.[0-9]+\.[0-9]+')
  cat <<EOF > .tflint.hcl
plugin "aws" {
    enabled = true
    version = "$ver"
    source  = "github.com/terraform-linters/tflint-ruleset-$PROVIDER"
}
EOF
else
  echo "Provider not defined because .tflint.hcl already exists in working directory"
fi