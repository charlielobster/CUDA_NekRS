Support scripts and documentation for CUDA NekRS installation on Ubuntu 24.04.3 LTS

0) Flash a hard drive with Ubuntu, then boot into it

   a) Find an erasable hard drive
   
   b) Transfer a bootable USB drive's Ubuntu image to the drive

       i) Inside your Windows instance, download the Ubuntu 24.04.3 iso file
       ii) Use Balena Etcher to write the iso to the USB drive
       iii) From your BIOS, boot from the USB drive and install to the target drive

    a) Setup git and github connection

       sudo apt install git         
       sudo apt install gh   
       # login to github using gh auth login and enter your credentials

    b) Other optional utilities
   
       sudo snap install --classic code # Visual Studio Code
       sudo apt install timeshift # Timeshift System Recovery
   
5) Maintain /home/$USER/CUDA_NekRS_vars.sh

   a) In a terminal, type:

         . ./CUDA_NekRS_vars.sh
       
   currently it just sets CUDA_HOME, modifies LD_LIBRARY_PATH, PATH etc

   it may evolve into a family of scripts, or a script that calls many other scripts

7) Topology

   These tools were compiled from source and reconfigured for CUDA support

   I created a folder called repos and put each in their respective locations with
8) something
9)    a) something
10)      i) something
11)        git clone https://github.com/openucx/ucx.git

12) someting
13)    a) something
14)      i) Something
            /home/USER/
            /home/USER/repos/CUDA_NekRS
            /home/USER/repos/ucx
            /home/USER/repos/ompi
            /home/USER/repos/OCCA
            /home/USER/repos/NekRS
   
10) Install CUDA

    a) Install or update CUDA drivers
    b) Install CUDA toolkit

       https://docs.nvidia.com/cuda/cuda-installation-guide-linux/

       See Install_CUDA_on_Ubuntu.txt for instructions

11) Install UCX

12) Install ompi

    For both steps I used:

        https://forums.developer.nvidia.com/t/how-to-build-ucx-openmpi-pytorch-with-cuda-distributed-on-agx-orin/341027


    a) We need to install gnu fortran first

    ...

13) Verify everything works (so far) with successful cuda_samples build

    c) build cuda samples
        
        i) we need glut, vulkan, freeimage, glfw3 libraries first

    ...

14) Install OCCA


15) Finally, install NekRS

