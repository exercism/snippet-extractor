#!/usr/bin/env bash

# Synopsis:
# Run the snippet extractor.

# Arguments:
# $1: track slug
# $2: path to source code
# $3: path to output directory (optional)

# Output:
# Extract the snippet from an iteration's code.
# If the output directory is specified, also write the response to that directory.

# Example:
# ./bin/run.sh csharp tests/csharp/simple.cs

# Stop executing when a command returns a non-zero return code
set -e

# If any required arguments is missing, print the usage and exit
if [[ $# -lt 2 ]]; then
    echo "usage: ./bin/run.sh track-slug <path/to/source/code/> [path/to/output/directory/]"
    exit 1
fi

track_slug="${1}"
source_code_file="${2}"
source_code=$(cat "${source_code_file}")

echo "${track_slug}: extracting snippet..."

#  the function with the correct JSON event payload
body_json=$(jq -n --arg l "${track_slug}" --arg s "${source_code}" '{language: $l, source_code: $s}')
event_json=$(jq -n --arg b "${body_json}" '{body: $b}')

ruby "./bin/run.rb" "${event_json}"

echo "${track_slug}: done"
