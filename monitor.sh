#!/bin/bash

URL="https://home.askemma.uk"
STATUS_FILE="status.txt"
DOWN_FILE="down_since.txt"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [ "$HTTP_CODE" != "200" ]; then
    STATUS="DOWN"
else
    STATUS="UP"
fi

PREV_STATUS=$(cat "$STATUS_FILE" 2>/dev/null)

NOW_EPOCH=$(date +%s)
NOW_HUMAN=$(date '+%d/%m/%Y %H:%M:%S')

if [ "$STATUS" != "$PREV_STATUS" ]; then
    echo "$STATUS" > "$STATUS_FILE"

    if [ "$STATUS" = "DOWN" ]; then
        echo "$NOW_EPOCH" > "$DOWN_FILE"
        curl -d "🚨 Emma Estate DOWN at $NOW_HUMAN (HTTP $HTTP_CODE)" ntfy.sh/emma-estate-matt-9472-blueforge
    else
        if [ -f "$DOWN_FILE" ]; then
            DOWN_EPOCH=$(cat "$DOWN_FILE")
            DURATION=$((NOW_EPOCH - DOWN_EPOCH))
            MINS=$((DURATION / 60))
            SECS=$((DURATION % 60))
            rm -f "$DOWN_FILE"
            curl -d "✅ Emma Estate RESTORED at $NOW_HUMAN after ${MINS}m ${SECS}s" ntfy.sh/emma-estate-matt-9472-blueforge
        else
            curl -d "✅ Emma Estate RESTORED at $NOW_HUMAN" ntfy.sh/emma-estate-matt-9472-blueforge
        fi
    fi
fi
