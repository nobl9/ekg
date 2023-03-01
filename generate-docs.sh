#!/bin/bash

readonly -a README_PATHS=(
    'modules/electrodes/kube-state-metrics'
    'modules/electrodes/kuberhealthy'
    'modules/electrodes/node-problem-detector'
    'modules/electrodes'
    'modules/adot-amp'
    '.'
)

for readme_path in "${README_PATHS[@]}"; do
   terraform-docs markdown table --output-file README.md --output-mode inject "${readme_path}"
done
