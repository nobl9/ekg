#!/bin/bash
set -euo pipefail

# Unfortunately multiple sub paths cannot be pass with --recursive-path flag, see https://github.com/terraform-docs/terraform-docs/issues/608.
terraform-docs markdown table --output-file README.md --output-mode inject --recursive --recursive-path './modules/electrodes' '.'
terraform-docs markdown table --output-file README.md --output-mode inject --recursive '.'
