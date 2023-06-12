import os

arguments = dict()

with open("./video-requests.txt") as f:
    counter = 0
    for line in f:
        line = line.strip()
        if line.startswith("#") or len(line) == 0:
            continue

        commands = line.split(' ')
        url = commands[0]

        path = str(counter)
        if commands[-1].startswith('='):
            path = commands.pop()[1:]
        counter += 1

        arguments.setdefault(url, []).append([*commands[1:], path])

for url, slices in arguments.items():
    os.system(f"yt-dlp {url} -o output.mp4 -f \"best[ext=mp4][height<=720]\"")
    for slice in slices:
        start = slice[0]
        end = slice[1]
        name = slice[2]
        os.system(f"ffmpeg -i output.mp4 -ss {start} -to {end} -y cut-output.mp4")
        os.system(f"mv cut-output.mp4 \"output-{name}.mp4\"")
        
    os.remove("output.mp4")
