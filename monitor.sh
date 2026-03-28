#!/bin/bash

URL="https://home.askemma.uk"
STATUS_FILE="status.txt"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" $URL)

if [ "$HTTP_CODE" != "200" ]; then
    STATUS="DOWN"
else
    STATUS="UP"
fi

PREV_STATUS=$(cat $STATUS_FILE 2>/dev/null)

if [ "$STATUS" != "$PREV_STATUS" ]; then
    echo $STATUS > $STATUS_FILE

    if [ "$STATUS" = "DOWN" ]; then
        curl -d "🚨 Emma Estate DOWN ($HTTP_CODE)" ntfy.sh/emma-estate-matt-9472-blueforge
    else
        curl -d "✅ Emma Estate RESTORED" ntfy.sh/emma-estate-matt-9472-blueforge
    fi
fi
