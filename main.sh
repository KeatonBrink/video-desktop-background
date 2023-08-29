#!/bin/bash



# <summary>
# This script is used to set a given video as the desktop background.
# </summary>
CURRENT_USER=$(whoami)
# set variables
if [ $# -ge 1 ]; then
    VIDEO_LOCATION=$1

    if [ $# -ge 2]; then
        TEMP_FILES=$2
    else
        TEMP_FILES=/tmp/video-desktop-background
    fi
else
    TEMP_FILES=/tmp/video-desktop-background
    VIDEO_LOCATION=/home/$CURRENT_USER/Videos/temp.mp4
fi

# check if the temporary files directory exists
if [ ! -d $TEMP_FILES ]; then
    mkdir $TEMP_FILES
else
    rm -rf $TEMP_FILES/*
    mkdir $TEMP_FILES
fi

# check if the temporary files directory is writable
if [ ! -w $TEMP_FILES ]; then
    echo "Temporary files directory is not writable."
    exit 1
fi

# check if the video exists
if [ ! -f $VIDEO_LOCATION ]; then
    echo "Video file does not exist."
    exit 1
fi

# check if the video is readable
if [ ! -r $VIDEO_LOCATION ]; then
    echo "Video file is not readable."
    exit 1
fi

# check if the video is a video
if [ ! $(file -b --mime-type $VIDEO_LOCATION) == "video/mp4" ]; then
    echo "Video file is not a video."
    exit 1
fi

# call ffmpeg to extract the frames
resolution=$(xrandr | grep "current" | cut -d' ' -f8,10)
read width height <<< $resolution
echo "After assignment: width=$width, height=$height, temp_files=$TEMP_FILES, video_location=$VIDEO_LOCATION"
ffmpeg -i $VIDEO_LOCATION -r 30 -f image2 $TEMP_FILES/%06d.jpg
