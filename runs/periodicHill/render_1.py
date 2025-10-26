import sys
import os
from paraview.simple import *

LoadState('/media/skooby/data/NekRS_runs/periodicHill/periodicHill_v2.pvsm')
renderView = GetRenderView()
renderView.ViewSize = [3840, 2160]
SaveAnimation('periodicHill.png', renderView, FrameWindow=[1268, 2296], ImageResolution=renderView.ViewSize, CompressionLevel=0)
