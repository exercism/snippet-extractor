BEGIN {
    RS = "^$"
}

END {
    gsub(/[[:space:]]/, "")
    if ($0 == "")
        print "Fine. Be that way!"
    else {
        yelling = /[A-Z]/ && !/[a-z]/
