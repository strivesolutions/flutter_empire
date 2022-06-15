#!/bin/bash

changes="$(git diff HEAD~1 HEAD | grep version:)"

# echo "[ $changes ]"
if [ "$changes" != "" ]; then
    version="$(cat pubspec.yaml | grep "version:" | cut -d" " -f 2)"
    echo $version
fi