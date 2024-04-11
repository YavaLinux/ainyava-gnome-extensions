#!/usr/bin/python
import os
import sys
import json
import requests
from http import HTTPStatus

with open('./extensions.txt', 'r') as f:
    extensions = f.read().splitlines()

base_url = 'https://extensions.gnome.org/api/v1/extensions'
wants = int(sys.argv[1])

for ext in extensions:

    if ext.startswith('#'):
        continue

    print('-'*50)

    not_found = False
    target_ver, next_page = False, f'{base_url}/{ext}/versions'

    while next_page and not target_ver:

        print(f'Fetching page {next_page}')
        r = requests.get(next_page)

        if not r.content:
            print(f'Skipping {ext}, (status: {r.status_code})')
            not_found = True
            break

        jd = json.loads(r.content)
        next_page = jd['next']
        
        
        filtered = [item for item in jd['results'] if item['shell_versions'][-1]['major'] == wants ]
        if len(filtered):
            target_ver = filtered[-1]['version']
    
    if not_found:
        continue

    print(f'{ext} -- {target_ver}')
