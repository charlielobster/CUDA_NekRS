#!/bin/bash
# render_paraview_pngs - invoke multiple render.py processes distributed to two GPUs

if [ $# -ne 6 ]; then
    echo "render_paraview_pngs <num processes> <working path> <state file path> <output pattern> <start frame> <end frame>"
fi

NUM_PROCESSES=$1
PREVIOUS_PATH=$(pwd)
WORKING_PATH=$2
STATE_FILE_PATH=$3
OUTPUT_PATTERN=$4
START_FRAME=$5
END_FRAME=$6

echo Number of Processes to Spawn: $NUM_PROCESSES
echo Working Directory: $WORKING_PATH
echo Paraview State File Path: $STATE_FILE_PATH
echo Output_Pattern: $OUTPUT_PATTERN
echo Start Frame: $START_FRAME
echo End Frame: $END_FRAME

RENDER_PY_PATH=$PREVIOUS_PATH/render.py
TOTAL_FRAMES=$((END_FRAME-START_FRAME+1))
FRAMES_PER_PROCESS=$((TOTAL_FRAMES/NUM_PROCESSES))
CURRENT_END_FRAME=$((START_FRAME-1))

echo Total Frames: $TOTAL_FRAMES
echo Frames Per Process: $FRAMES_PER_PROCESS

cd $WORKING_PATH

for ((i=0; i<$NUM_PROCESSES; i+=2));
do
    CURRENT_START_FRAME=$((CURRENT_END_FRAME+1))
    CURRENT_END_FRAME=$((CURRENT_START_FRAME+FRAMES_PER_PROCESS))

    # echo Setting values for Start Frame: $CURRENT_START_FRAME and End Frame: $CURRENT_END_FRAME
    pvpython --displays 0 --force-offscreen-rendering $RENDER_PY_PATH $STATE_FILE_PATH $OUTPUT_PATTERN $CURRENT_START_FRAME $CURRENT_END_FRAME &

    CURRENT_START_FRAME=$((CURRENT_END_FRAME+1))
    
    if [ "$i" -eq $(("$NUM_PROCESSES"-2)) ]; then
        CURRENT_END_FRAME=$((END_FRAME))
    else
        CURRENT_END_FRAME=$((CURRENT_START_FRAME+FRAMES_PER_PROCESS))
    fi

    # echo Setting values for Start Frame: $CURRENT_START_FRAME and End Frame: $CURRENT_END_FRAME
    pvpython --displays 1 --force-offscreen-rendering $RENDER_PY_PATH $STATE_FILE_PATH $OUTPUT_PATTERN $CURRENT_START_FRAME $CURRENT_END_FRAME &

done

wait

cd $PREVIOUS_PATH