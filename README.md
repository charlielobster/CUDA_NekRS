Support scripts and documentation for CUDA NekRS installation on Ubuntu 24.04.3 LTS

0) Flash a hard drive with Ubuntu, then boot into it

   a) Transfer a bootable USB drive's Ubuntu image to the drive

    i) Inside your Windows instance, download the Ubuntu 24.04.3 iso file
    ii) Use Balena Etcher to write the iso to the USB drive
    iii) From your BIOS, boot from the USB drive and install to the target drive

   b) Setup git and github connection

       sudo apt install git         
       sudo apt install gh   
       # login to github using gh auth login and enter your credentials

   c) Other optional utilities
   
       sudo snap install --classic code # Visual Studio Code
       sudo apt install timeshift # Timeshift System Recovery
   
1) Maintain /home/$USER/CUDA_NekRS_vars.sh

   a) In a terminal, type:

         . ./CUDA_NekRS_vars.sh
       
This is the script you'll use before running programs in NekRS.
It performs housekeeping like setting CUDA_HOME, modifying LD_LIBRARY_PATH, PATH etc.
Perhaps add this to your .profile, or terminal initialization.
   
2) Install CUDA

    a) Install or update CUDA drivers
    b) Install CUDA toolkit

       https://docs.nvidia.com/cuda/cuda-installation-guide-linux/

       See Install_CUDA_on_Ubuntu.txt for instructions


3) Topology

   These tools were compiled from source and configured for CUDA support

   Create a folder called repos and put each tool in their respective locations

        mkdir repos
        cd repos
        git clone https://github.com/charlielobster/CUDA_NekRS.git
        git clone https://github.com/openucx/ucx.git
        git clone https://github.com/open-mpi/ompi.git
        git clone https://github.com/libocca/occa.git
        git clone https://github.com/Nek5000/nekRS.git

   Your topology should now look like this:

        /home/USER/
        /home/USER/repos/CUDA_NekRS
        /home/USER/repos/ucx
        /home/USER/repos/ompi
        /home/USER/repos/OCCA
        /home/USER/repos/nekRS


4) Install UCX

5) Install ompi

    For both steps I used:

    https://forums.developer.nvidia.com/t/how-to-build-ucx-openmpi-pytorch-with-cuda-distributed-on-agx-orin/341027


    but before we install ompi, we need to install gnu fortran first

    ...

6) Verify everything works (so far) with successful cuda_samples build

      a) we need glut, vulkan, freeimage, glfw3 libraries first
    
      b) build cuda samples
        

    ...

15) Install OCCA


16) Finally, install NekRS

