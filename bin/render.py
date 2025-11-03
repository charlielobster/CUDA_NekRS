# render.py - use the paraview cli to open a file and render a range of pngs from its animation sequence
# type: ignore
import sys
import os
from paraview.simple import *

if len(sys.argv) < 5:
    print("render.py <state file path> <output pattern> <start frame> <end frame>")

state_file_path = sys.argv[1]
output_pattern = sys.argv[2]
start_frame = int(sys.argv[3])
end_frame = int(sys.argv[4])

frame_window = [start_frame, end_frame]

LoadState(state_file_path)
renderView = GetRenderView()
renderView.ViewSize = [3840, 2160]

SaveAnimation(output_pattern, renderView, FrameWindow=frame_window, ImageResolution=renderView.ViewSize, CompressionLevel=0)
