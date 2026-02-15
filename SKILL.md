# Yoinkit Social — OpenClaw Skill

Research trending content and pull transcripts from social platforms.

## Requirements

- **Yoinkit subscription** with API access enabled
- **API Token** from Yoinkit Settings → OpenClaw

## Configuration

Set your API token in OpenClaw config:

```bash
# Via chat command
/config skills.yoinkit-social.env.YOINKIT_API_TOKEN "your-token-here"
```

Or edit `~/.openclaw/openclaw.json`:

```json
{
  "skills": {
    "entries": {
      "yoinkit-social": {
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

Extract transcript from any video URL.

**Supported:** YouTube, TikTok, Instagram Reels, Facebook, Twitch

```bash
yoinkit transcript https://youtube.com/watch?v=abc123
yoinkit transcript https://tiktok.com/@user/video/123
```

---

### `yoinkit content <url>`

Get full content and metadata from any social post.

**Supported:** All 14 platforms (YouTube, TikTok, Instagram, Twitter/X, Reddit, LinkedIn, etc.)

```bash
yoinkit content https://twitter.com/user/status/123
yoinkit content https://reddit.com/r/technology/comments/abc
```

---

### `yoinkit search <platform> "<query>" [options]`

Search for content on a platform.

**Options:**
- `--limit N` — Number of results (default: 10)
- `--sort TYPE` — Sort by: relevance, date, views
- `--time RANGE` — Time filter: hour, day, week, month, year

```bash
yoinkit search youtube "AI tools for creators"
yoinkit search tiktok "productivity tips" --limit 20
yoinkit search reddit "home automation" --sort top --time week
```

---

### `yoinkit trending <platform> [options]`

Get currently trending content.

**Options:**
- `--category CAT` — Category filter (YouTube: tech, gaming, music, etc.)
- `--country CODE` — Country code (default: US)
- `--limit N` — Number of results (default: 20)

```bash
yoinkit trending youtube --category tech
yoinkit trending tiktok --country US
yoinkit trending reddit
```

---

### `yoinkit research "<topic>" [options]`

Automated research workflow — combines search, trending, and optional transcripts.

**Options:**
- `--platforms LIST` — Comma-separated platforms (default: youtube,tiktok,twitter)
- `--depth MODE` — Research depth: quick, normal, deep
- `--transcripts` — Pull transcripts from top videos (deep mode only)

```bash
yoinkit research "home automation"
yoinkit research "AI tools" --platforms youtube,tiktok,reddit --depth deep
```

**What it does:**
1. Searches each platform for the topic
2. Gets trending content in that space
3. (Deep mode) Pulls transcripts from top videos
4. Summarizes themes, angles, and opportunities

---

## Natural Language

You don't need exact command syntax. Just ask your assistant naturally:

> "What's trending on YouTube in tech?"

> "Pull the transcript from this TikTok: [url]"

> "Find viral Reddit posts about home automation from this week"

> "Do deep research on creator economy trends"

---

## Cron Examples

### Daily Trend Check (9 AM)

```json
{
  "name": "Daily Trends",
  "schedule": { "kind": "cron", "expr": "0 9 * * *", "tz": "America/Chicago" },
  "payload": {
    "kind": "agentTurn",
    "message": "Check yoinkit trending for youtube and tiktok in tech/AI. Summarize what's hot today."
  },
  "sessionTarget": "isolated",
  "delivery": { "mode": "announce" }
}
```

### Weekly Deep Research (Monday 10 AM)

```json
{
  "name": "Weekly Research",
  "schedule": { "kind": "cron", "expr": "0 10 * * 1", "tz": "America/Chicago" },
  "payload": {
    "kind": "agentTurn",
    "message": "Run yoinkit research on my niches (AI tools, productivity, creator economy) with --depth deep. Identify 3 content ideas I haven't covered."
  },
  "sessionTarget": "isolated"
}
```

---

## API Base URL

All requests go through your Yoinkit subscription:

```
https://yoinkit.com/api/v1/openclaw/
```

---

## Documentation

Full API documentation: https://openclaw.yoinkit.ai

---

## Support

- Issues: https://github.com/seomikewaltman/yoinkit-openclaw-skill/issues
- Yoinkit: https://yoinkit.com
