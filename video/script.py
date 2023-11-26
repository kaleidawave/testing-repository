import os

videos = dict()
audios = list()

with open("./video-requests.txt") as f:
    video_counter = 0
    for line in f:
        line = line.strip()
        if line.startswith("#") or len(line) == 0:
            continue

        commands = line.split(" ")
        if commands[0] == "audio":
            audios.append(commands[1])
        else:
            # Can be elided or non existent
            if commands[0] == "video":
                commands.pop(0)

            url = commands[0]

            path = str(video_counter)
            # Overwrite path if set
            if commands[-1].startswith("="):
                path = commands.pop()[1:]  # [1:] removes '='
            else:
                video_counter += 1

            height = "720"
            if commands[1].startswith("(") and commands[1].endswith("p)"):
                height = commands.pop(1)[1:-2]  # remove '(' and 'p)'

            start, end = commands[1:]

            request = {"start": start, "end": end, "path": path, "height": height}

            videos.setdefault(url, []).append(request)

for url, requests in videos.items():
    # Assume height is consistent
    height = requests[0]["height"]

    try:
        print(f"Downloading {url} with {height}")

        os.system(f'yt-dlp {url} -o output.mp4 -f "best[ext=mp4][height<={height}]"')
        for request in requests:
            from operator import attrgetter

            print(request)

            start, end, path = attrgetter("start", "end", "path")(request)

            print(f"Snipping {start} to {end} for {path}")

            os.system(f"ffmpeg -i output.mp4 -ss {start} -to {end} -y cut-output.mp4")
            os.system(f'mv cut-output.mp4 "output-{path}.mp4"')

        os.remove("output.mp4")
    except Exception as e:
        print(f"error downloading {url} {e}")

for audio in audios:
    print(f"Downloading audio {audio}")
    os.system(f'yt-dlp {audio} -x --audio-format mp3 -o "%(title)s.%(ext)s"')
