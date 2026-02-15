#!/bin/bash
# yoinkit search <platform> <query>
# Search content across social platforms

set -e

PLATFORM="$1"
QUERY="$2"
shift 2 2>/dev/null || true

# Supported platforms with search
SUPPORTED_PLATFORMS=("youtube" "tiktok" "instagram" "reddit" "pinterest")

# Validate platform
if [[ ! " ${SUPPORTED_PLATFORMS[@]} " =~ " ${PLATFORM} " ]]; then
    echo "Error: Platform $PLATFORM does not support search or is not supported"
    echo "Supported platforms: ${SUPPORTED_PLATFORMS[*]}"
    exit 1
fi

if [ -z "$QUERY" ]; then
    echo "Error: Query required"
    echo "Usage: yoinkit search <platform> \"<query>\" [options]"
    exit 1
fi

if [ -z "$YOINKIT_API_TOKEN" ]; then
    echo "Error: YOINKIT_API_TOKEN not configured"
    exit 1
fi

API_BASE="${YOINKIT_API_URL:-https://yoinkit.ai/api/v1/openclaw}"

# Default parameters
LIMIT=10
SORT=""

# Parse additional options
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --limit)
            LIMIT="$2"
            shift 2
            ;;
        --sort)
            SORT="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Build query params
QUERY_PARAMS="query=$(echo "$QUERY" | jq -sRr @uri)&limit=$LIMIT"
if [ -n "$SORT" ]; then
    QUERY_PARAMS+="&sort=$SORT"
fi

# Make API request
RESPONSE=$(curl -s -H "Authorization: Bearer $YOINKIT_API_TOKEN" \
    "$API_BASE/$PLATFORM/search?$QUERY_PARAMS")

# Check for errors
if echo "$RESPONSE" | jq -e '.success == false' > /dev/null 2>&1; then
    ERROR=$(echo "$RESPONSE" | jq -r '.error.message // .error // "Unknown error"')
    echo "Error: $ERROR"
    exit 1
fi

# Output formatted results from data wrapper
echo "$RESPONSE" | jq '.data // .'
