import os

videos = dict()
audios = list()

with open("./video-requests.txt") as f:
    video_counter = 0
    for line in f:
        line = line.strip()
        if line.startswith("#") or len(line) == 0:
            continue

        commands = line.split(' ')
        if commands[0] == "audio":
            audios.append(commands[1])
        else:
            url = commands[0]

            path = str(video_counter)
            if commands[-1].startswith('='):
                path = commands.pop()[1:]
            video_counter += 1

            videos.setdefault(url, []).append([*commands[1:], path])

for url, slices in videos.items():
    os.system(f"yt-dlp {url} -o output.mp4 -f \"best[ext=mp4][height<=720]\"")
    for slice in slices:
        start = slice[0]
        end = slice[1]
        name = slice[2]
        os.system(f"ffmpeg -i output.mp4 -ss {start} -to {end} -y cut-output.mp4")
        os.system(f"mv cut-output.mp4 \"output-{name}.mp4\"")
        
    os.remove("output.mp4")

for audio in audios:
    os.system(f"yt-dlp {audio} -x --audio-format mp3 -o \"%(title)s.%(ext)s\"")