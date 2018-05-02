#!/usr/bin/env bash

# FeedTube, a feed video downloader for Youtube
# Copyright Carlos Fenollosa <cf@cfenollosa.com>, 2018. Licensed under the GNU GPL v3: https://www.gnu.org/licenses/gpl-3.0.en.html
# Check out README.md for more details

# Check dependencies
[[ $(which youtube-dl) ]] || (echo "Error: missing youtube-dl. Download it here: https://github.com/rg3/youtube-dl/" && exit)
[[ $(which xmlstarlet) ]] || (echo "Error: missing xmlstarlet. Download it here: http://xmlstar.sourceforge.net/" && exit)

# If invoked with an URL, download that URL and exit
if [[ $1 ]] && [[ $1 == http* ]]; then
    echo "Downloading video..."
    youtube-dl -q --no-warnings -f 'bestvideo[ext=mp4+height<=1080]+bestaudio[ext=m4a]' "$1"
    exit
fi

# Detect first run
DOWNLOADED_IDS=.downloaded_ids
OPML=$(ls *.xml 2> /dev/null)
LIST_CSV=.list.csv
if [[ ! -f $DOWNLOADED_IDS ]]; then
    [[ -z $OPML ]] && echo "First run setup: Missing subscriptions file. Please follow these instructions: https://support.google.com/youtube/answer/6224202?hl=en" && exit
    [[ -f $LIST_CSV ]] && echo "First run setup: existing $LIST_CSV. Stopping" && exit
    cat $OPML | sed -e $'s/ \/>/\\\n/g' | sed 's/.*title="\(.*\)" type.*xmlUrl="\(.*\)".*/\1	\2/g'| grep youtube > $LIST_CSV
    echo -n "" > $DOWNLOADED_IDS
    FIRST_RUN=1
    echo -n "First run setup: Download latest videos for all subscriptions? This may take a long time/bandwidth (y/N) "
    read DOWNLOAD
fi

[[ ! -f $LIST_CSV ]] && echo "Error: $LIST_CSV not found. Please run setup again" && exit

while read SUB; do
    IFS=$'\t' read CHANNEL FEED <<< "$SUB"
    [[ $1 == "-q" ]] || echo Processing $CHANNEL...

    # Download xml file
    R_FILE=.$RANDOM.xml
    wget -q $FEED -O $R_FILE
    [[ ! -s $R_FILE ]] && echo "Error downloading xml" && rm $R_FILE && continue

    # Parse elements
    xmlstarlet sel -N atom="http://www.w3.org/2005/Atom" -t -m "/atom:feed/atom:entry" -v atom:title -n $R_FILE > $R_FILE.title
    xmlstarlet sel -N atom="http://www.w3.org/2005/Atom" -t -m "/atom:feed/atom:entry/atom:link" -v @href -n $R_FILE > $R_FILE.href
    xmlstarlet sel -N atom="http://www.w3.org/2005/Atom" -t -m "/atom:feed/atom:entry" -v atom:id -n $R_FILE > $R_FILE.id
    xmlstarlet sel -N atom="http://www.w3.org/2005/Atom" -t -m "/atom:feed/atom:entry" -v atom:published -n $R_FILE > $R_FILE.published
    paste  $R_FILE.id $R_FILE.title $R_FILE.href $R_FILE.published > $R_FILE.pasted

    # Check if videos have been downloaded
    while read LINE; do
        IFS=$'\t' read ID TITLE HREF PUBLISHED <<< "$LINE"

        # Check if already downloaded
        OUT=$(grep "$ID" $DOWNLOADED_IDS)
        [[ $? -eq 0 ]] && continue

        # Set file name
        FILENAME="[$CHANNEL] - $TITLE"

        # Download it
        shopt -s nocasematch
        if [[ -z $FIRST_RUN ]] || [[ $DOWNLOAD == "y" ]] ; then
            [[ $1 == "-q" ]] || echo "Downloading $FILENAME"
            youtube-dl -q --no-warnings -f 'bestvideo[ext=mp4+height<=1080]+bestaudio[ext=m4a]' -o "$FILENAME" "$HREF"
        fi

        # Mark as downloaded 
        echo -e "$FILENAME\t$ID" >> $DOWNLOADED_IDS

    done < $R_FILE.pasted

    rm $R_FILE*

done < $LIST_CSV

[[ $FIRST_RUN ]] && rm $OPML && echo "First run finished. Subsequent runs of this script will download new videos. Enjoy!"
