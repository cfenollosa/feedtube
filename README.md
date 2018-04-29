# feedtube
A feed video downloader for Youtube

Feedtube is for you if:

- You are a fan of RSS
- The Youtube website is glitchy for you, or you want to use Youtube anonymously or without signing up to Google
- You need to download videos and watch them offline
- You want to watch videos without ads. Note that, as such, video creators and Youtube don't get paid

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

Downloaded filenames have the format: `[Channel name] - Video name`. File timestamp is set by `youtube-dl` as the video upload date.

## Configuration

- `-q` Quiet mode. No output is generated, except errors
- `<Youtube URL>` Single video run. Downloads the selected video and exits. No feeds are parsed.

You can also edit the script to change parameters for `youtube-dl`, like the maximum quality (set to 1080p by default) or video format. [Read youtube-dl documentation](https://github.com/rg3/youtube-dl/blob/master/README.md#readme) for more information.

## Adding new subscriptions

Edit `.list.csv` with a text editor and add a new line, with the format:

`Channel title <TAB> channel RSS address`

IMPORTANT NOTE: Next time you run `feedtube.sh`, it will download all videos for that channel. If you don't want that--I don't--, just Ctrl-C just as the video download starts and then remove any temporal files. Maybe this will be fixed in a future release.

## Watching videos

Downloaded videos can be watched using any standard video player.

I use [Miro](http://www.getmiro.com) to watch videos. I have set it up to "watch" the downloads folder for new videos, and lets me organize it by date, size, and others. Furthermore, the video player keeps track of the time you stop watching and lets you resume, like Youtube.

You can also simulate Youtube's sorting options using your OS file explorer:

- Sort by channel: Sort by filename
- Sort by upload date: Sort by file date

# Changelog

- 1.0, 2018-04-29. First working release
