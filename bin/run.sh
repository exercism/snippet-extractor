#!/bin/bash

# Usage:
# ./bin/run.sh two_fer ~/solution/ ~/output/

# Stop executing when a command returns a non-zero return code
set -e

ruby bin/run.rb $1 $2 $3
