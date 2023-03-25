import os

arguments = dict()

with open("./video-requests.txt") as f:
    counter = 0
    for line in f:
        line = line.strip()
        commands = line.split(' ')
        url = commands[0]

        path = str(counter)
        if commands[-1].startswith('='):
            path = commands.pop()[1:]
        counter += 1

        arguments.setdefault(url, []).append([*commands[1:], path])

print(arguments)

for url, slices in arguments.items():
    os.system(f"yt-dlp {url} -o output.mp4 -f mp4")
    for slice in slices:
        start = slice[0]
        end = slice[1]
        name = slice[2]
        print(f"Snipping out {start} to {end}")
        os.system(f"ffmpeg -i output.mp4 -ss {start} -to {end} -y cut-output.mp4")
        os.system(f"mv cut-output.mp4 \"output-{name}.mp4\"")
    os.remove("rm output.mp4")
