# Yoinkit Platform Capabilities

| Platform | Content | Transcript | Search | Trending | User Feed | Notes |
|----------|:-------:|:----------:|:------:|:--------:|:---------:|-------|
| YouTube | ✅ | ✅ | ✅ | ✅ | ✅ | Full support; channel videos via handle or ID |
| TikTok | ✅ | ✅ | ✅ | ✅ | ✅ | trending, popular, hashtags endpoints |
| Instagram | ✅ | ✅ | ✅ | ❌ | ✅ | Search reels; user posts and reels |
| Twitter/X | ✅ | ✅ | ❌ | ❌ | ✅ | Content and user tweets |
| Facebook | ✅ | ✅ | ❌ | ❌ | ✅ | Posts and reels from pages |
| LinkedIn | ✅ | ❌ | ❌ | ❌ | ❌ | Post content only |
| Reddit | ✅ | ❌ | ✅ | ❌ | ❌ | Search + subreddit browsing |
| Pinterest | ✅ | ❌ | ✅ | ❌ | ❌ | Pin content and search |
| Threads | ✅ | ❌ | ❌ | ❌ | ✅ | Post content and user posts |
| Bluesky | ✅ | ❌ | ❌ | ❌ | ✅ | Post content and user posts |
| Truth Social | ✅ | ❌ | ❌ | ❌ | ✅ | Post content and user posts |
| Twitch | ✅ | ❌ | ❌ | ❌ | ❌ | Clips only |
| Kick | ✅ | ❌ | ❌ | ❌ | ❌ | Clips only |

## Endpoint Quick Reference

### Content (single post/video)
- `youtube/video?url=URL`
- `tiktok/video?url=URL`
- `instagram/post?url=URL` or `?shortcode=SC`
- `twitter/tweet?url=URL`
- `facebook/post?url=URL`
- `linkedin/post?url=URL`
- `reddit/post?url=URL`
- `pinterest/pin?url=URL`
- `threads/post?url=URL`
- `bluesky/post?url=URL`
- `truthsocial/post?url=URL`
- `twitch/clip?url=URL`
- `kick/clip?url=URL`

### Transcript
- `youtube/transcript?url=URL`
- `tiktok/transcript?url=URL`
- `instagram/transcript?url=URL`
- `twitter/transcript?url=URL`
- `facebook/transcript?url=URL`

### Search
- `youtube/search?query=Q&limit=N`
- `youtube/search/hashtag?hashtag=H&limit=N`
- `tiktok/search?query=Q&limit=N`
- `tiktok/search/hashtag?hashtag=H&limit=N`
- `tiktok/search/top?query=Q&limit=N`
- `instagram/search?query=Q&limit=N`
- `reddit/search?query=Q&limit=N`
- `reddit/subreddit?subreddit=S&limit=N&sort=hot|new|top`
- `reddit/subreddit/search?query=Q&limit=N`
- `pinterest/search?query=Q&limit=N`

### Trending
- `youtube/trending?country=CC&limit=N`
- `tiktok/trending?country=CC`
- `tiktok/popular?limit=N`
- `tiktok/hashtags?limit=N`

### User Feed
- `youtube/channel/videos?channelId=ID` or `?handle=H&limit=N`
- `tiktok/user/videos?handle=H` or `?user_id=ID&limit=N`
- `instagram/user/posts?handle=H`
- `instagram/user/reels?handle=H` or `?user_id=ID`
- `twitter/user/tweets?handle=H` or `?userId=ID&limit=N`
- `facebook/user/posts?url=URL` or `?pageId=ID`
- `facebook/user/reels?url=URL` or `?pageId=ID&cursor=C`
- `threads/user/posts?handle=H`
- `bluesky/user/posts?handle=H` or `?user_id=ID&limit=N`
- `truthsocial/user/posts?handle=H` or `?user_id=ID`
