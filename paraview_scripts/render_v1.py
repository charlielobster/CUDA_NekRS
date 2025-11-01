import sys
import os
from paraview.simple import *

LoadState('/media/skooby/New Volume/NekRS_runs/periodicHill/periodicHill.pvsm')
renderView = GetRenderView()
renderView.ViewSize = [3840, 2160]
SaveAnimation('periodicHill.png', renderView, FrameWindow=[0, 7993], ImageResolution=renderView.ViewSize, CompressionLevel=0)
