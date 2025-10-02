#!/bin/bash
set -euo pipefail
START_TIME=$(date +%s)


sleep 2

END_TIME=$(date +%s)

TOTAL_TIME=$(($END_TIME-$START_TIME))

echo "script executed in $TOTAL_TIME"


