#!/bin/bash

# Entrypoint for printing HTML to PDF using headless chrome.  If a url was provided as input print
# that url, oherwise use any input file piped in.  If a file was piped and and a url was provided
# we could perform some other action in the future such as a REPL loop.

set -e

INPUT=
INPUT_SIZE=0
OUTPUT=/home/chrome/printed.pdf

# If url provided use it, otherwise check stdin

if [[ "$1" == http* ]]; then
    INPUT=$1
else
    # Check if there was data on stdin. Wait 1 second for input and then fail if nothing.
    IFS= read -t 1 -r line;
    if [[ -n $line ]]; then
        INPUT=/home/chrome/input.html
        echo $line > $INPUT
        cat >> $INPUT
        INPUT_SIZE=$(stat --format "%s" $INPUT)
    fi
fi

if [[ -z $INPUT ]]; then
    exit 1
fi

chromium --headless --disable-gpu -no-sandbox --run-all-compositor-stages-before-draw --virtual-time-budget=10000 --print-to-pdf-no-header --print-to-pdf=$OUTPUT $INPUT

cat $OUTPUT
exit 0
