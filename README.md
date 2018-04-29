# feedtube
A feed video downloader for Youtube

I'm a fan of RSS and Youtube is quite glitchy for me. Feedtube is a script that lets me download videos

## Dependencies

[xmlstarlet](http://xmlstar.sourceforge.net) and [youtube-dl](https://github.com/rg3/youtube-dl/)

## Setup

1. Just download `feedtube.sh` or clone the repo: `git clone https://github.com/cfenollosa/feedtube`
2. Download your Youtube subscriptions. Follow the official instructions: https://support.google.com/youtube/answer/6224202?hl=en
3. Place the downloaded file on the same folder as feedtube
4. Run `./feedtube.sh`

That's it!

## Running Feedtube

Running `feedtube.sh` will download new videos for your subscriptions. There's nothing more to it :)

## Configuration

- `-q` Quiet mode. No output is generated, except errors
- `<Youtube URL>` Single video run. Downloads the selected video and exits. No feeds are parsed.

You can also edit the script to change parameters for `youtube-dl`, like the maximum quality (set to 1080p by default) or video format. [Read youtube-dl documentation](https://github.com/rg3/youtube-dl/blob/master/README.md#readme) for more information.

## Watching videos

I use [Miro](http://www.getmiro.com) to watch videos. I have set it up to "watch" the downloads folder for new videos, and lets me organize it by date, size, and others.

Furthermore, the video player keeps track of the time you stop watching and lets you resume, like Youtube.
