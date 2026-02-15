#!/bin/bash
# yoinkit transcript <url>
# Extract transcript from video URL

set -e

URL="$1"

if [ -z "$URL" ]; then
    echo "Error: URL required"
    echo "Usage: yoinkit transcript <url>"
    exit 1
fi

if [ -z "$YOINKIT_API_TOKEN" ]; then
    echo "Error: YOINKIT_API_TOKEN not configured"
    exit 1
fi

API_BASE="${YOINKIT_API_URL:-https://yoinkit.ai/api/v1/openclaw}"

# Detect platform and construct endpoint
if [[ "$URL" == *"youtube.com"* ]] || [[ "$URL" == *"youtu.be"* ]]; then
    ENDPOINT="youtube/transcript?url=$(echo "$URL" | jq -sRr @uri)"
elif [[ "$URL" == *"tiktok.com"* ]]; then
    ENDPOINT="tiktok/transcript?url=$(echo "$URL" | jq -sRr @uri)"
elif [[ "$URL" == *"instagram.com"* ]]; then
    ENDPOINT="instagram/transcript?url=$(echo "$URL" | jq -sRr @uri)"
elif [[ "$URL" == *"twitter.com"* ]] || [[ "$URL" == *"x.com"* ]]; then
    ENDPOINT="twitter/transcript?url=$(echo "$URL" | jq -sRr @uri)"
elif [[ "$URL" == *"facebook.com"* ]]; then
    ENDPOINT="facebook/transcript?url=$(echo "$URL" | jq -sRr @uri)"
else
    echo "Error: Platform does not support transcripts or URL not recognized"
    echo "Supported: YouTube, TikTok, Instagram, Twitter/X, Facebook"
    exit 1
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

# Output transcript from data wrapper
echo "$RESPONSE" | jq -r '.data.transcript // .data // .'
