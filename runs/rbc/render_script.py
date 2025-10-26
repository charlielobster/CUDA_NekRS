import sys
import os
from paraview.simple import *

LoadState('/home/skooby/builds/NekRS/examples/rbc/rbc.pvsm')

renderView = GetRenderView()
renderView.ViewSize = [3840, 2160]
output_pattern = 'rbc.png'
frame_window = [201, 558]

SaveAnimation(output_pattern, renderView, FrameWindow=frame_window, ImageResolution=renderView.ViewSize, CompressionLevel=0)
