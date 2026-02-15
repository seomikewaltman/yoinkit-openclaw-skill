#!/bin/bash
# yoinkit trending <platform>
# Get trending content across platforms

set -e

PLATFORM="$1"
shift 2>/dev/null || true

# Supported platforms with trending
SUPPORTED_PLATFORMS=("youtube" "tiktok")

# Validate platform
if [[ ! " ${SUPPORTED_PLATFORMS[@]} " =~ " ${PLATFORM} " ]]; then
    echo "Error: Platform $PLATFORM does not support trending or is not supported"
    echo "Supported platforms: ${SUPPORTED_PLATFORMS[*]}"
    exit 1
fi

if [ -z "$YOINKIT_API_TOKEN" ]; then
    echo "Error: YOINKIT_API_TOKEN not configured"
    exit 1
fi

API_BASE="${YOINKIT_API_URL:-https://yoinkit.ai/api/v1/openclaw}"

# Default parameters
LIMIT=20
COUNTRY="US"
TYPE="trending"  # For TikTok: trending, popular, hashtags

# Parse additional options
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --limit)
            LIMIT="$2"
            shift 2
            ;;
        --country)
            COUNTRY="$2"
            shift 2
            ;;
        --type)
            TYPE="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Construct endpoint based on platform and type
if [[ "$PLATFORM" == "youtube" ]]; then
    ENDPOINT="youtube/trending?country=$COUNTRY&limit=$LIMIT"
elif [[ "$PLATFORM" == "tiktok" ]]; then
    case "$TYPE" in
        trending)
            ENDPOINT="tiktok/trending?country=$COUNTRY"
            ;;
        popular)
            ENDPOINT="tiktok/popular?limit=$LIMIT"
            ;;
        hashtags)
            ENDPOINT="tiktok/hashtags?limit=$LIMIT"
            ;;
        *)
            echo "Error: Unknown TikTok trending type: $TYPE"
            echo "Supported types: trending, popular, hashtags"
            exit 1
            ;;
    esac
fi

# Make API request
RESPONSE=$(curl -s -H "Authorization: Bearer $YOINKIT_API_TOKEN" \
    "$API_BASE/$ENDPOINT")

# Check for errors
if echo "$RESPONSE" | jq -e '.success == false' > /dev/null 2>&1; then
    ERROR=$(echo "$RESPONSE" | jq -r '.error.message // .error // "Unknown error"')
    echo "Error: $ERROR"
    exit 1
fi

# Output formatted results from data wrapper
echo "$RESPONSE" | jq '.data // .'
