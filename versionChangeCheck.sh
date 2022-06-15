#!/bin/bash

changes="$(git diff HEAD~1 HEAD pubspec.yaml | grep version:)"

# echo "[ $changes ]"
if [ "$changes" != "" ]; then
    version="$(cat pubspec.yaml | grep "version:" | cut -d" " -f 2)"
    echo $version
fi