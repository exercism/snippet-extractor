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
