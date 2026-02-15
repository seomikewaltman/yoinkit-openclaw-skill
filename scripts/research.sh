#!/bin/bash
# yoinkit research <topic>
# Automated research workflow — combines search and trending across platforms

set -e

TOPIC="$1"
shift 2>/dev/null || true

if [ -z "$TOPIC" ]; then
    echo "Error: Topic required"
    echo "Usage: yoinkit research \"<topic>\" [options]"
    exit 1
fi

if [ -z "$YOINKIT_API_TOKEN" ]; then
    echo "Error: YOINKIT_API_TOKEN not configured"
    exit 1
fi

API_BASE="${YOINKIT_API_URL:-https://yoinkit.com/api/v1/openclaw}"

# Default parameters
PLATFORMS=("youtube" "tiktok")
TRANSCRIPTS=false
LIMIT=10

# Parse additional options
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --platforms)
            IFS=',' read -r -a PLATFORMS <<< "$2"
            shift 2
            ;;
        --transcripts)
            TRANSCRIPTS=true
            shift
            ;;
        --limit)
            LIMIT="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Platforms that support search
SEARCH_PLATFORMS=("youtube" "tiktok" "instagram" "reddit" "pinterest")
# Platforms that support trending
TRENDING_PLATFORMS=("youtube" "tiktok")
# Platforms that support transcripts
TRANSCRIPT_PLATFORMS=("youtube" "tiktok" "instagram" "twitter" "facebook")

echo "{"
echo "  \"topic\": \"$TOPIC\","
echo "  \"results\": {"

FIRST_PLATFORM=true

for platform in "${PLATFORMS[@]}"; do
    if [ "$FIRST_PLATFORM" = false ]; then
        echo ","
    fi
    FIRST_PLATFORM=false

    echo "    \"$platform\": {"

    # Search if platform supports it
    if [[ " ${SEARCH_PLATFORMS[@]} " =~ " ${platform} " ]]; then
        SEARCH_RESPONSE=$(curl -s -H "Authorization: Bearer $YOINKIT_API_TOKEN" \
            "$API_BASE/$platform/search?query=$(echo "$TOPIC" | jq -sRr @uri)&limit=$LIMIT")

        if echo "$SEARCH_RESPONSE" | jq -e '.success == false' > /dev/null 2>&1; then
            echo "      \"search\": null,"
        else
            echo "      \"search\": $(echo "$SEARCH_RESPONSE" | jq '.data // []'),"
        fi
    else
        echo "      \"search\": null,"
    fi

    # Trending if platform supports it
    if [[ " ${TRENDING_PLATFORMS[@]} " =~ " ${platform} " ]]; then
        if [[ "$platform" == "youtube" ]]; then
            TRENDING_RESPONSE=$(curl -s -H "Authorization: Bearer $YOINKIT_API_TOKEN" \
                "$API_BASE/youtube/trending?country=US&limit=$LIMIT")
        else
            TRENDING_RESPONSE=$(curl -s -H "Authorization: Bearer $YOINKIT_API_TOKEN" \
                "$API_BASE/tiktok/trending?country=US")
        fi

        if echo "$TRENDING_RESPONSE" | jq -e '.success == false' > /dev/null 2>&1; then
            echo "      \"trending\": null"
        else
            # Check if we need transcripts
            if [ "$TRANSCRIPTS" = true ] && [[ " ${TRANSCRIPT_PLATFORMS[@]} " =~ " ${platform} " ]]; then
                TRENDING_DATA=$(echo "$TRENDING_RESPONSE" | jq '.data // []')
                # Get first 3 video URLs for transcripts
                URLS=$(echo "$TRENDING_DATA" | jq -r '.[0:3] | .[] | .url // empty' 2>/dev/null)

                TRANSCRIPTS_JSON="["
                FIRST_TRANSCRIPT=true
                for url in $URLS; do
                    if [ -n "$url" ]; then
                        if [ "$FIRST_TRANSCRIPT" = false ]; then
                            TRANSCRIPTS_JSON+=","
                        fi
                        FIRST_TRANSCRIPT=false

                        TRANSCRIPT_RESPONSE=$(curl -s -H "Authorization: Bearer $YOINKIT_API_TOKEN" \
                            "$API_BASE/$platform/transcript?url=$(echo "$url" | jq -sRr @uri)")

                        if echo "$TRANSCRIPT_RESPONSE" | jq -e '.success != false' > /dev/null 2>&1; then
                            TRANSCRIPTS_JSON+="{\"url\":\"$url\",\"transcript\":$(echo "$TRANSCRIPT_RESPONSE" | jq '.data.transcript // .data // null')}"
                        fi
                    fi
                done
                TRANSCRIPTS_JSON+="]"

                echo "      \"trending\": $TRENDING_DATA,"
                echo "      \"transcripts\": $TRANSCRIPTS_JSON"
            else
                echo "      \"trending\": $(echo "$TRENDING_RESPONSE" | jq '.data // []')"
            fi
        fi
    else
        echo "      \"trending\": null"
    fi

    echo -n "    }"
done

echo ""
echo "  }"
echo "}"
