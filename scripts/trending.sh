#!/bin/bash
# yoinkit trending <platform> [options]
# Get trending content on a platform

set -e

PLATFORM="$1"
shift || true

# Parse options
LIMIT=20
COUNTRY="US"
CATEGORY=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --limit)
            LIMIT="$2"
            shift 2
            ;;
        --country)
            COUNTRY="$2"
            shift 2
            ;;
        --category)
            CATEGORY="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

if [ -z "$PLATFORM" ]; then
    echo "Error: Platform required"
    echo "Usage: yoinkit trending <platform> [--limit N] [--country CODE] [--category CAT]"
    exit 1
fi

if [ -z "$YOINKIT_API_TOKEN" ]; then
    echo "Error: YOINKIT_API_TOKEN not configured"
    exit 1
fi

API_BASE="${YOINKIT_API_URL:-https://yoinkit.com/api/v1/openclaw}"

# Build query params
PARAMS="limit=$LIMIT&country=$COUNTRY"
if [ -n "$CATEGORY" ]; then
    PARAMS="$PARAMS&category=$CATEGORY"
fi

ENDPOINT="$PLATFORM/trending?$PARAMS"

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
