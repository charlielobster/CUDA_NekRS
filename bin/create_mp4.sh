#!/bin/bash
# convenience script for saving some frequently-used yet cryptic ffmeg options

if [ $# -ne 2 ]; then
    echo "create_mp4 <png regex path> <path to mp4>"
    # for example, 
    # ./create_mp4.sh .../CUDA_NekRS/artifacts/pngs/tcf.%04d.png .../CUDA_NekRS/artifacts/mp4s/tcf.mp4
fi

ffmpeg -framerate 50 -i $1 -c:v libx264 -pix_fmt yuv420p $2