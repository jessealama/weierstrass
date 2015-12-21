BEGIN {
    RS = "&"
    FS = "="
    print "{"
}

{
    printf "\t\"%s\": \"%s\"\n", $1, $2
}

END {
    print "}"
}
