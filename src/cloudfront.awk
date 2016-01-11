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
    numFiles = 0
    print "["
}

function enrich(property, n, j)
{
    if ("cs-uri-query" == property) {
        queryString = logs[n][property]
        delete logs[n][property]
        parsed = urlDecode(queryString)
        split(queryString, pairs, "&")
        len = length(pairs)
        for (j = 1; j <= len; j++) {
            split(pairs[j], keyValue, "=")
            k = keyValue[1]
            v = keyValue[2]
            result[k] = v
            logs[n][property][k] = v
        }
    }
}

END {
    print "{"
    printf "\"version\": \"%s\",\n", version
    print "\"records\": ["
    numLogs = length(logs)
    i = 1
    for (lineNr in logs)
    {
        printf "{\n";
        for (j = 1; j <= numFields; j++)
        {
            field = fields[j]
            enrich(field, lineNr)
            if(isarray(logs[lineNr][field])) {
                printf "\"%s\": {\n", field
                k = 1
                numSubFields = length(logs[lineNr][field])
                for (subField in logs[lineNr][field]) {
                    printf "\"%s\": \"%s\"", subField, logs[lineNr][field][subField]
                    if (k < numSubFields) {
                        printf ","
                    }
                    k++
                    printf "\n"
                }
                printf "}"
            } else {
                printf "\"%s\": \"%s\"", field, logs[lineNr][field]
            }
            if (j < numFields) {
                printf ","
            }
            printf "\n"
        }
        printf "}"
        if (i < numLogs) {
            printf ","
        }
        printf "\n"
        i++
    }
    print "]"
    printf "}"
    if (numFiles + 1 < ARGC) {
        printf ","
    }
    printf "\n"
    print "]"
}

ENDFILE {
    numFiles++
}

/^#Version: / {
    version = substr($0, length("#Version: ") + 1)
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
    split($0, fieldsThisLine, " ")
    numFieldsThisLine = length(fieldsThisLine)
    for (i = 1; i <= numFieldsThisLine; i++)
    {
         logs[NR][fields[i]] = fieldsThisLine[i]
    }
}
