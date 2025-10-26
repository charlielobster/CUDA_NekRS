import sys
import os
from paraview.simple import *

LoadState('/media/skooby/data/NekRS_runs/turbPipePeriodic/turbPipe.pvsm')
renderView = GetRenderView()
renderView.ViewSize = [3840, 2160]
SaveAnimation('turbPipe.png', renderView, FrameWindow=[0, 4166], ImageResolution=renderView.ViewSize, CompressionLevel=0)
