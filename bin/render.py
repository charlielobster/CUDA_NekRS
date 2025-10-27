import sys
import os
from paraview.simple import *

if len(sys.argv) < 5:
    print("render.py <state file path> <output pattern> <start frame> <end frame>")

state_file_path = sys.argv[1]
output_pattern = sys.argv[2]
start_frame = int(sys.argv[3])
end_frame = int(sys.argv[4])

print("state_file_path: {}".format(state_file_path))
print("output_pattern: {}".format(output_pattern))
print("start_frame: {}".format(start_frame))
print("end_frame: {}".format(end_frame))

frame_window = [start_frame, end_frame]

LoadState(state_file_path)
renderView = GetRenderView()
renderView.ViewSize = [3840, 2160]

SaveAnimation(output_pattern, renderView, FrameWindow=frame_window, ImageResolution=renderView.ViewSize, CompressionLevel=0)
