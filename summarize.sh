#!/usr/bin/env bash

README=$1
echo $README

if [ -f $README ]; then 
    ollama run llama2 "summarize this file:" "$(cat $README)"
else
    echo "README.md not found"
fi
