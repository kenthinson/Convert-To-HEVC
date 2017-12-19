# _   _ _______     ______    ____                          _            
# | | | | ____\ \   / / ___|  / ___|___  _ ____   _____ _ __| |_ ___ _ __ 
# | |_| |  _|  \ \ / / |     | |   / _ \| '_ \ \ / / _ \ '__| __/ _ \ '__|
# |  _  | |___  \ V /| |___  | |__| (_) | | | \ V /  __/ |  | ||  __/ |   
# |_| |_|_____|  \_/  \____|  \____\___/|_| |_|\_/ \___|_|   \__\___|_| 
#Author Kent Hinson


#!/bin/bash
#Script to auto convert media to hevc using ffmpeg
#All files in passed directory will be processed.

#Varibles
deleteWhenFinished="no"
#loop over each file in directory given

#Store users choice about deleting original files
echo "Delete Original files after processing? (Default no. Type yes and press enter to enable delete)"
read deleteWhenFinished

#loop each file in given directory
for file in $1/*
do
	#store filename without file extention
	filename="${file%.*}"

	#use exiftool to see if file is a vieo / has HEVC encoding
	exiftool "$file" | grep -q "Video"
	isVideo=$?
	exiftool "$file" | grep -q "HEVC"
	isHEVC=$?

	#if the file is a video and is not HEVC encoding then start the reencode.
	if [ $isVideo -eq 0 ] && [ $isHEVC -eq 1 ]; then
		echo "Converting $file"
		ffmpeg -i "$file" -map 0:0? -map 0:1? -map 0:2? -map 0:3? -map 0:4? -map 0:5? -map 0:6? -map 0:7? -map 0:8? -map 0:9? -c:v libx265 -preset ultrafast -x265-params crf=22:qcomp=0.8:aq-mode=1:aq_strength=1.0:qg-size=16:psy-rd=0.7:psy-rdoq=5.0:rdoq-level=1:merange=44 -c:a copy -b:a 160k -c:s copy  "$filename-hevc.mkv"

		#if the ffmpeg exited without error and the delete choce is yes then delete the original file
		if [ $? -eq 0 ] && [ "$deleteWhenFinished" = "yes" ]; then
			rm $file
		fi
	else
		#the file is not a video or is already HEVC encoded.
		echo "Skipping $file"
	fi
done
