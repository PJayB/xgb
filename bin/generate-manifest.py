#!/usr/bin/python3

import json
import argparse
import hashlib

args = argparse.ArgumentParser(prog='generate-manifest')
args.add_argument('-i', '--input-file', required=True)

args = args.parse_args()

with open(args.input_file) as json_file:
    files = json.load(json_file)

def hash(path):
    hasher = hashlib.new('sha1')

    with open(path, 'rb') as file:
        while chunk := file.read(65536):
            hasher.update(chunk)

    return hasher.hexdigest()

for file in files.keys():
    files[file] = hash(file)

print(json.dumps(files))
