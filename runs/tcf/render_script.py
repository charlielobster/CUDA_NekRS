import sys
import os
from paraview.simple import *

# Check for command line arguments: start frame and number of frames
if len(sys.argv) != 4:
    print("Usage: pvbatch render_script.py <start_frame> <num_frames> <state_file_path>")
    sys.exit(1)


output_pattern = 'tcf.png'
start_frame = int(sys.argv[1])
num_frames = int(sys.argv[2])
state_file_path = sys.argv[3]
end_frame = start_frame + num_frames

frame_window = [start_frame, end_frame]

# Get the animation scene and view
LoadState(state_file_path)

renderView = GetRenderView()
renderView.ViewSize = [3840, 2160]

print("saving animation")

SaveAnimation(output_pattern, renderView, FrameWindow=frame_window, ImageResolution=renderView.ViewSize)

print("done")

"""
animationScene = GetAnimationScene()
renderView = GetRenderView()

# Get the frame time information from the animation scene
timesteps = animationScene.Timesteps
if not timesteps:
    print("No timesteps found in the animation scene.")
    sys.exit(1)

# Set the 4K resolution (3840x2160)
renderView.ViewSize = [3840, 2160]

# Create an output directory if it doesn't exist
output_dir = "rendered_frames"
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# Render the specified range of frames
for i in range(start_frame, end_frame):
    if i >= len(timesteps):
        print(f"Skipping frame {i}: no corresponding timestep.")
        continue

    # Set the animation time to the current frame's time step
    animationScene.AnimationTime = timesteps[i]
    
    # Construct the output filename with padding (e.g., frame_0000.png)
    output_path = os.path.join(output_dir, f"frame.{i:04d}.png")
    
    # Save the screenshot
    SaveScreenshot(output_path, renderView)
    print(f"Rendered frame {i} to {output_path}")

print("Rendering complete.")
"""