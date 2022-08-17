#!/bin/bash

pubspecVersion="$(cat pubspec.yaml | grep "version:" | cut -d" " -f 2)"
readmeVersion="$(cat README.md | grep "empire:" | cut -d"^" -f 2)"
changeLogHeader="$(head -n 1 CHANGELOG.md)"

if [ "$pubspecVersion" != "$readmeVersion" ]; then
    echo "pubspec: $pubspecVersion"
    echo "readme: $readmeVersion"
    echo "::error file=README.md::Version does not match pubspec.yaml"
    exit 1
fi

expectedChangeLogHeader="## $pubspecVersion"
if [ "$expectedChangeLogHeader" != "$changeLogHeader" ]; then
    echo "pubspec: $pubspecVersion"
    echo "changelog: $changeLogHeader"
    echo "::error file=CHANGELOG.md::Change log should begin with $expectedChangeLogHeader"
    exit 1
fi