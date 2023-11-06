#!/bin/bash

# Based on this repository: https://github.com/drwestt/Nagios2GoogleChat

URL='' # In env
id='' # In env

IFS='%' # Internal Field Separator

curl -4 -X POST \
    "$URL" \
    -H 'Content-Type: text/json; charset=utf-8' \
    -d '{
        "text": "*`'$2'`:`'$4'`*\n```Notification: '$5'\n'$6'```",
        "thread": {
            "name": "'$id'"
        }
    }'

unset IFS