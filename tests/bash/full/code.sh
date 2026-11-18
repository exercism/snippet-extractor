#!/usr/bin/env bash
#
# Isogram check.
# Usage: isogram.sh <phrase>

# Lowercase the input and strip anything that is not a letter.
LOWERCASE_INPUT="${1,,}"
declare -A seen

for (( i = 0; i < ${#LOWERCASE_INPUT}; i++ )); do
    char="${LOWERCASE_INPUT:i:1}"
    [[ $char == [a-z] ]] || continue
    if [[ -n ${seen[$char]} ]]; then # already seen
        echo false
        exit 0
    fi
    seen[$char]=1
done
echo true
