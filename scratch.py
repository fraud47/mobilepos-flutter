import urllib.request
import json
import re

url = "https://pub.dev/api/packages/drift"
response = urllib.request.urlopen(url)
data = json.loads(response.read())

for ver in reversed(data['versions']):
    v = ver['version']
    sq = ver['pubspec'].get('dependencies', {}).get('sqlite3', '')
    if '^2.' in sq:
        print(f"drift {v} uses sqlite3 {sq}")
        break

url2 = "https://pub.dev/api/packages/drift_dev"
response2 = urllib.request.urlopen(url2)
data2 = json.loads(response2.read())
for ver in reversed(data2['versions']):
    v = ver['version']
    br = ver['pubspec'].get('dependencies', {}).get('build_runner', '')
    if br:
        print(f"drift_dev {v} uses build_runner {br}")
