BEGIN {
    RS = "^$"
}

END {
    gsub(/[[:space:]]/, "")
    if ($0 == "")
        print "Fine. Be that way!"
    else {
        yelling = /[A-Z]/ && !/[a-z]/
        asking  = /?$/
        switch (yelling "" asking) {
            case "11": print "Calm down, I know what I'm doing!"; break
            case "10": print "Whoa, chill out!"; break
            case "01": print "Sure."; break
