#!/bin/bash



# <summary>
# This script is used to set a given video as the desktop background.
# </summary>
CURRENT_USER=$(whoami)
# set variables
if [ $# -ge 1]; then
    VIDEO_LOCATION="$1"

    if [ $# -ge 2]; then
        TEMP_FILES="$2"
    else
        TEMP_FILES=/tmp/video-desktop-background
    fi
else
    VIDEO_LOCATION=/home/$CURRENT_USER/Videos/temp.mp4
fi

# check if the video exists
if [ ! -f "$VIDEO_LOCATION" ]; then
    echo "Video file does not exist."
    exit 1
fi

# check if the video is readable
if [ ! -r "$VIDEO_LOCATION" ]; then
    echo "Video file is not readable."
    exit 1
fi

# check if the video is a video
if [ ! $(file -b --mime-type "$VIDEO_LOCATION") == "video/mp4" ]; then
    echo "Video file is not a video."
    exit 1
fi

# call ffmpeg to extract the frames
resolution=$(xrandr | grep "current" | cut -d' ' -f8,10)
read width height <<< "$resolution"
ffmpeg -i "$VIDEO_LOCATION" -vf scale=$width:$height -r 30 -f image2 "$TEMP_FILES"/%06d.jpg
