# yoinkit-social

OpenClaw skill for social media research powered by Yoinkit.

## Features

- 🔍 **Search** — Find content across YouTube, TikTok, Twitter, Instagram, Reddit, and more
- 📈 **Trending** — See what's trending on each platform
- 📝 **Transcripts** — Extract transcripts from videos
- 📊 **Research** — Automated research workflows combining multiple API calls

## Requirements

- [OpenClaw](https://openclaw.ai) installed
- Active [Yoinkit](https://yoinkit.com) subscription
- API token from Yoinkit Settings → OpenClaw

## Installation

```bash
# Clone this repository
git clone https://github.com/seomikewaltman/yoinkit-openclaw-skill.git

# Add to your OpenClaw config
# Edit ~/.openclaw/openclaw.json:
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

Or configure via chat:

```
/config skills.yoinkit-social.env.YOINKIT_API_TOKEN "your-token"
```

## Usage

### Commands

```bash
# Get a transcript
yoinkit transcript https://youtube.com/watch?v=abc123

# Get post content
yoinkit content https://twitter.com/user/status/123

# Search a platform
yoinkit search youtube "AI tools for creators" --limit 10

# Get trending content
yoinkit trending tiktok --country US

# Full research workflow
yoinkit research "home automation" --platforms youtube,reddit --depth deep
```

### Natural Language

Just ask your assistant:

> "What's trending on YouTube in the AI space?"

> "Find viral Reddit posts about productivity from this week"

> "Pull the transcript from this TikTok and summarize the key points"

## Cron Examples

See the `examples/` directory for ready-to-use cron job configurations:

- `daily-trends.json` — Morning trend check
- `weekly-research.json` — Deep research every Monday
- `viral-alert.json` — Hourly viral content monitoring

## Documentation

Full API documentation: https://openclaw.yoinkit.ai

## License

MIT
