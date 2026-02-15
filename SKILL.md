# Yoinkit — OpenClaw Skill

Research content and pull transcripts from social platforms.

## Platform Reference

**Before running commands**, check [references/platforms.md](references/platforms.md) for:
- Which platforms support transcript/trending/search/user feed
- Platform-specific parameters and options
- How to handle unsupported operations

## Requirements

- **Yoinkit subscription** with API access enabled
- **API Token** from Yoinkit Settings → OpenClaw

## Configuration

Set your API token in OpenClaw config:

```bash
# Via chat command
/config skills.yoinkit.env.YOINKIT_API_TOKEN "your-token-here"
```

Or edit `~/.openclaw/openclaw.json`:

```json
{
  "skills": {
    "entries": {
      "yoinkit": {
        "path": "/path/to/yoinkit-openclaw-skill",
        "env": {
          "YOINKIT_API_TOKEN": "your-token-here"
        }
      }
    }
  }
}
```

## Commands

### `yoinkit transcript <url>`

Extract transcript from video URL.

**Supported:** YouTube, TikTok, Instagram, Twitter/X, Facebook

```bash
yoinkit transcript https://youtube.com/watch?v=abc123
yoinkit transcript https://tiktok.com/@user/video/123
yoinkit transcript https://instagram.com/reel/abc123
```

---

### `yoinkit content <url>`

Get full content and metadata from social post.

**Supported:** YouTube, TikTok, Instagram, Twitter/X, Facebook, LinkedIn, Reddit, Pinterest, Threads, Bluesky, Truth Social, Twitch, Kick

```bash
yoinkit content https://twitter.com/user/status/123
yoinkit content https://reddit.com/r/technology/comments/abc
yoinkit content https://bsky.app/profile/user.bsky.social/post/abc
```

---

### `yoinkit search <platform> "<query>" [options]`

Search content on a platform.

**Supported for Search:** YouTube, TikTok, Instagram, Reddit, Pinterest

**Options:**
- `--limit N` — Number of results (default: 10)
- `--sort TYPE` — Sort by: relevance, date, views (platform-dependent)

```bash
yoinkit search youtube "AI tools for creators"
yoinkit search tiktok "productivity tips" --limit 20
yoinkit search reddit "home automation" --sort top
yoinkit search instagram "fitness motivation" --limit 10
```

---

### `yoinkit trending <platform> [options]`

Get currently trending content.

**Supported for Trending:** YouTube, TikTok

**Options:**
- `--country CODE` — Country code (default: US)
- `--limit N` — Number of results (default: 20)
- `--type TYPE` — For TikTok: `trending`, `popular`, or `hashtags`

```bash
yoinkit trending youtube --country US
yoinkit trending tiktok --country US
yoinkit trending tiktok --type popular --limit 50
yoinkit trending tiktok --type hashtags
```

---

### `yoinkit research "<topic>" [options]`

Automated research workflow — combines search and trending across platforms.

**Options:**
- `--platforms LIST` — Comma-separated platforms (default: youtube,tiktok)
- `--transcripts` — Also fetch transcripts from top results
- `--limit N` — Results per platform (default: 10)

```bash
yoinkit research "home automation"
yoinkit research "AI tools" --platforms youtube,tiktok,reddit
yoinkit research "productivity" --transcripts --limit 5
```

**What it does:**
1. Searches each platform for the topic
2. Gets trending content from supported platforms
3. Optionally fetches transcripts from top video results
4. Returns combined results for analysis

---

## Natural Language

You don't need exact command syntax:

> "What's trending on TikTok?"

> "Pull the transcript from this YouTube video: [url]"

> "Find popular Reddit posts about home automation"

---

## API Base URL

All requests go through your Yoinkit subscription:

```
https://yoinkit.com/api/v1/openclaw
```

---

## Documentation

Full API documentation: https://openclaw.yoinkit.ai

---

## Support

- Issues: https://github.com/seomikewaltman/yoinkit-openclaw-skill/issues
- Yoinkit: https://yoinkit.com
