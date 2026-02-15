#!/bin/bash
# yoinkit search <platform> "<query>" [options]
# Search for content on a platform

set -e

PLATFORM="$1"
QUERY="$2"
shift 2 || true

# Parse options
LIMIT=10
SORT="relevance"
TIME=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --limit)
            LIMIT="$2"
            shift 2
            ;;
        --sort)
            SORT="$2"
            shift 2
            ;;
        --time)
            TIME="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

if [ -z "$PLATFORM" ] || [ -z "$QUERY" ]; then
    echo "Error: Platform and query required"
    echo "Usage: yoinkit search <platform> \"<query>\" [--limit N] [--sort TYPE] [--time RANGE]"
    exit 1
fi

if [ -z "$YOINKIT_API_TOKEN" ]; then
    echo "Error: YOINKIT_API_TOKEN not configured"
    exit 1
fi

API_BASE="${YOINKIT_API_URL:-https://yoinkit.com/api/v1/openclaw}"

# Build query params
PARAMS="query=$(echo "$QUERY" | jq -sRr @uri)&limit=$LIMIT&sort=$SORT"
if [ -n "$TIME" ]; then
    PARAMS="$PARAMS&time=$TIME"
fi

ENDPOINT="$PLATFORM/search?$PARAMS"

# Make API request
RESPONSE=$(curl -s -H "Authorization: Bearer $YOINKIT_API_TOKEN" \
    "$API_BASE/$ENDPOINT")

# Check for errors
if echo "$RESPONSE" | jq -e '.success == false' > /dev/null 2>&1; then
    ERROR=$(echo "$RESPONSE" | jq -r '.error.message')
    echo "Error: $ERROR"
    exit 1
fi

# Output results
echo "$RESPONSE" | jq '.data'
