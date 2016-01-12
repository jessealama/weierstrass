import sys
from os import listdir
from os.path import join, expanduser, isdir, dirname
from glob import glob
import gzip
import re
import urllib.parse
import base64
import binascii
import json

if len(sys.argv) != 2:
    print("Exactly one argument is expected.")
    exit(1)

def readGzipLog(gzippedLogFile):
    lines = []
    fields = None
    version = None
    f = gzip.open(gz, 'rt')
    for line in f:
        line = line.rstrip('\n')
        if re.match('^#Fields: ', line):
            fields = line[len('#Fields: '):].split(' ')
        elif re.match('^#Version: ', line):
            version = line[len('#Version: '):]
        else:
            i = 0
            record = {}
            s = line.split('\t')
            for field in fields:
                record[field] = s[i]
                i = i + 1
            lines.append(record)
    return {
        'version': version,
        'lines': lines,
        'path': gzippedLogFile
    }

dir = sys.argv[1]

if not isdir(dir):
    print("'" + dir + "' is not a directory.")
    exit(1)

gzs = glob(join(dir, '*.gz'))
logs = []

for gz in gzs:
    log = readGzipLog(gz)
    lines = log['lines']
    for record in lines:
        for key in record.keys():
            if key == 'cs-uri-query':
                newRecord = {}
                val = record['cs-uri-query']
                s = val.split('&')
                if len(s) > 1:
                    for p in s:
                        s2 = p.split('=')
                        if len(s2) == 2:
                            newRecord[s2[0]] = s2[1]
                        elif len(s2) == 1:
                            newRecord[s2[0]] = None
                        record['cs-uri-query'] = newRecord
    for record in lines:
        for key in record.keys():
            if key == 'cs(User-Agent)':
                val = record['cs(User-Agent)']
                record['cs(User-Agent)'] = urllib.parse.unquote(urllib.parse.unquote(val))
            elif key == 'cs-uri-query':
                val = record['cs-uri-query']
                if isinstance(val, dict):
                    for key in val.keys():
                        if key == 'url' or key == 'tz' or key == 'page' or key == 'refr' or key == 'se_la':
                            val = record['cs-uri-query'][key]
                            record['cs-uri-query'][key] = urllib.parse.unquote(urllib.parse.unquote(val))
                        elif key == 'ue_px':
                            val = record['cs-uri-query'][key]
                            val += '=' * ((4 - len(val) % 4) % 4)
                            newVal = base64.b64decode(val, '-_').decode()
                            record['cs-uri-query'][key] = json.loads(newVal)
    logs.append(log)

print(json.dumps(logs))
