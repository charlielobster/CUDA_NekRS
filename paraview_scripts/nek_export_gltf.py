# Import the ParaView Simple API
from paraview.simple import *

def export_nek5000_to_gltf(nek5000_file = "turbPipe.nek5000", gltf_file = "turbPipe.gltf"):
    """
    Reads a Nek5000 dataset, creates a visualization pipeline, and exports
    the scene as a glTF file.

    Args:
        nek5000_file (str): The path to the .nek5000 metadata file.
        gltf_file (str): The desired output path for the .gltf file.
    """
    # Create a new ParaView session
    # Connect to the server if running in client-server mode
    # e.g., Connect("localhost", 11111)

    # 1. Create a reader for the Nek5000 file
    print(f"Reading Nek5000 file: {nek5000_file}")
    nekReader = Nek5000Reader(FileName=nek5000_file)

    # 2. Get the active view (the 3D render view)
    renderView = GetActiveViewOrCreate('RenderView')

    # 3. Create a representation of the data and show it in the view
    # You may need to specify which array to display if there are multiple.
    # For a simple export, the default rendering may be sufficient.
    nekDisplay = Show(nekReader, renderView)

    # 4. Optional: Configure the visualization
    # This example colors by velocity magnitude (if available).
    # Replace 'Velocity' with another variable name if needed.
    try:
        ColorBy(nekDisplay, ('POINTS', 'Velocity'))
        # Use a predefined color map
        velocityLUT = GetColorTransferFunction('Velocity')
        velocityLUT.ApplyPreset('Viridis (Plasma)')
    except:
        print("Could not color by 'Velocity'. Using default coloring.")

    # 5. Reset the camera to fit the data
    ResetCamera(renderView)

    # 6. Export the scene to glTF
    print(f"Exporting scene to glTF file: {gltf_file}")
    ExportView(gltf_file, view=renderView)

    # 7. Disconnect and finish
    Disconnect()
    print("Export complete.")


if __name__ == '__main__':
    # Define your input and output filenames
    input_file = "turbPipe.nek5000"
    output_file = "turbPipe.gltf"

    # Call the export function
    export_nek5000_to_gltf(input_file, output_file)