function printUrlQueryString(queryString, j)
{
    split(queryString, pairs, "&")
    len = length(pairs)
    for (j = 1; j < len; ++j) {
        split(pairs[j], keyValue, "=")
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

function urlDecode(url, i) {
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
    logLineSeen = 0
    print "{";
}

END {
    print "}"
}

/^#Version: / {
    printf "\t\"version\": \"%s\",\n", substr($0, length("#Version: ") + 1)
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
    urlIndex = 0
    if (NF == numFields) {
        print "\t{"
        for(i = 1; i < NF; i++)
        {
            fieldName = fields[i]
            if (fieldName == "cs-uri-query") {
                urlIndex = i;
                continue;
            }
            fieldValue = fieldsThisLine[i]
            maybeDecoded = (fieldName == "cs-uri-query" ? urlDecode(fieldValue) : fieldValue)
            printf "\t\t\"%s\": \"%s\"", fieldName, fieldValue
            if (i + 1 < NF && urlIndex > 0) {
                printf ","
            }
            printf "\n"
        }
        if (urlIndex > 0) {
            printf "\t\t\"cs-url-query\": {\n"
            printUrlQueryString(fieldsThisLine[urlIndex])
            printf "}\n"
        }
        printf "\t}"
    }
    logLineSeen = 1;
}
