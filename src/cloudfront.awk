function printUrlQueryString(queryString)
{
    split(queryString, pairs, "&", seps)
    len = length(pairs)
    for (j = 1; j < len; ++j) {
        split(pairs[j], keyValue, "=", seps2)
        k = keyValue[1]
        v = keyValue[2]
        printf "\t\t\"%s\": \"%s\",\n", k, urlDecode(urlDecode(v))
    }
}

function base64Decode(thing)
{
  "echo "$thing" | base64 --decode" | getline x
  return x
}

function urlDecode(url) {
    for (i = 0x20; i < 0x40; ++i) {
        repl = sprintf("%c", i);
        if ((repl == "&") || (repl == "\\")) {
            repl = "\\" repl;
        }
        url = gensub(sprintf("%%%02X", i), repl, "g", url);
        url = gensub(sprintf("%%%02x", i), repl, "g", url);
    }
    return url;
}

BEGIN {
    print "{";
}

END {
    print "}"
}

/^#Version: / {
    printf "\t\"version\": \"%s\",\n", substr($0, length("#Version: ") + 1)
    logLineSeen = 0
}

/^#Fields: / {
    rest = substr($0, length("#Fields: ") + 1)
    split(rest, fields, " ")
    numFields = length(fields)
}

/^#/ {
    # ignore anything else starting with "#"
}

! /^#/ {
    if (logLineSeen == 1) {
        printf ",\n"
    }
    split($0, fieldsThisLine, " ")
    if (NF == numFields) {
        print "\t{"
        for(i = 1; i < NF; i++)
        {
            printf "\t\t\"%s\": \"%s\"", fields[i], fieldsThisLine[i]
            if (i + 1 < NF) {
                printf ","
            }
            printf "\n"
        }
        printf "\t}"
    }
    logLineSeen = 1;
}
