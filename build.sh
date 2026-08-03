#!/usr/bin/env bash
# Build the distributable zip. Everything under src/ ships, nothing outside it does.
# Prints the path of the zip it made.
set -euo pipefail
cd "$(dirname "$0")"

read -r name version < <(python3 -c "
import json
info = json.load(open('src/info.json'))
print(info['name'], info['version'])
")
folder="${name}_${version}"

rm -rf build
mkdir -p "build/${folder}"
cp -R src/. "build/${folder}/"
(cd build && zip -rq "${folder}.zip" "${folder}" -x '.*' '*/.*')

echo "build/${folder}.zip"
