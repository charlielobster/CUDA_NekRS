# !/bin/bash
# ./create_mp4.sh <png regex path> <path to mp4>

ffmpeg -framerate 50 -i $1 -c:v libx264 -pix_fmt yuv420p $2