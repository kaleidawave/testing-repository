[testing_repo](https://github.com/kaleidawave/testing_repo)

### Video requests

Check with this command first

```shell
# List available formats for url
yt-dlp --list-formats *url*
```

Videos are downloaded per URL. That means taking several sections, only happens once.

Items prefixed with
- `#` are ignored
- `audio` only download audio
- `video` only download video
- nothing try to download the best audio and video

- Add `(xxxxp)` after the URL to set the min height
- The next two items denote the timestamps from where to trim ( #TODO there should be a way to say the whole video )
- Add `=...` to set the output name
