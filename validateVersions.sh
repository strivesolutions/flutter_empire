#!/bin/bash

pubspecVersion="$(cat pubspec.yaml | grep "version:" | cut -d" " -f 2)"
readmeVersion="$(cat README.md | grep "empire:" | cut -d"^" -f 2)"

if [ "$pubspecVersion" != "$readmeVersion" ]; then
    echo "pubspec: $pubspecVersion"
    echo "readme: $readmeVersion"
    echo "::error file=README.md::Version does not match pubspec.yaml"
    exit 1
fi
