#!/bin/bash
# yoinkit transcript <url>
# Extract transcript from a video URL

set -e

URL="$1"

if [ -z "$URL" ]; then
    echo "Error: URL required"
    echo "Usage: yoinkit transcript <url>"
    exit 1
fi

if [ -z "$YOINKIT_API_TOKEN" ]; then
    echo "Error: YOINKIT_API_TOKEN not configured"
    echo "Set it via: /config skills.yoinkit-social.env.YOINKIT_API_TOKEN \"your-token\""
    exit 1
fi

API_BASE="${YOINKIT_API_URL:-https://yoinkit.com/api/v1/openclaw}"

# Detect platform from URL
if [[ "$URL" == *"youtube.com"* ]] || [[ "$URL" == *"youtu.be"* ]]; then
    # Extract video ID
    if [[ "$URL" == *"youtu.be"* ]]; then
        VIDEO_ID=$(echo "$URL" | sed 's/.*youtu\.be\///' | sed 's/\?.*//')
    else
        VIDEO_ID=$(echo "$URL" | sed 's/.*[?&]v=//' | sed 's/&.*//')
    fi
    ENDPOINT="youtube/transcript?id=$VIDEO_ID"
elif [[ "$URL" == *"tiktok.com"* ]]; then
    ENDPOINT="tiktok/transcript?url=$(echo "$URL" | jq -sRr @uri)"
elif [[ "$URL" == *"instagram.com"* ]]; then
    ENDPOINT="instagram/transcript?url=$(echo "$URL" | jq -sRr @uri)"
else
    echo "Error: Unsupported platform"
    echo "Supported: YouTube, TikTok, Instagram Reels"
    exit 1
fi

# Make API request
RESPONSE=$(curl -s -H "Authorization: Bearer $YOINKIT_API_TOKEN" \
    "$API_BASE/$ENDPOINT")

# Check for errors
if echo "$RESPONSE" | jq -e '.success == false' > /dev/null 2>&1; then
    ERROR=$(echo "$RESPONSE" | jq -r '.error.message')
    echo "Error: $ERROR"
    exit 1
fi

# Output transcript
echo "$RESPONSE" | jq -r '.data.transcript // .data'
