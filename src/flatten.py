import sys
from os.path import isdir
import json

properties = ["time",
              "date",
              "x-edge-location",
              "c-ip",
              "cs(Referer)",
              "url",
              "cs",
              "tz",
              "ds",
              "vp",
              "aid",
              "p",
              "res",
              "sid",
              "e",
              "lang",
              "tv",
              "duid",
              "page",
              "eid",
              "dtm",
              "cs(User-Agent)"]

def traverse(obj, disk):
    if isinstance(obj, dict):
        for key in obj.keys():
            if (key in properties):
                disk[key] = obj[key]
            disk = traverse(obj[key], disk)
    elif isinstance(obj, list):
        for i in obj:
            disk = traverse(i, disk)
    return disk

if len(sys.argv) != 2:
    print("Exactly one argument is expected.", file=sys.stderr)
    exit(1)

file = sys.argv[1]

if isdir(file):
    print(file + " is not a file", file=sys.stderr)
    exit(1)

with open(file, encoding='utf-8') as json_file:
    parsed_json = json.load(json_file)

flattened = []

if isinstance(parsed_json, list):
    for i in parsed_json:
        lines = i['lines']
        for line in lines:
            flattened.append(traverse(line, {}))

print(json.dumps(flattened))
