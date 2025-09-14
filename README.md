Support scripts and documentation for CUDA NekRS installation on Ubuntu 24.04.3 LTS

0) Flash a hard drive with Ubuntu, then boot into it

   a) Find a hard drive

   b) Start with a USB drive containing the etched iso

       i) On your windows box, download the 24.04.3 iso file

       ii) Use Balena Etcher to write the iso to the USB drive

       iii) From your BIOS, boot from the USB drive and install to the target drive

1) Some additional software:

    a) something

       i) sudo apt install git
   
       i) sudo apt install gh
   
       i) % login to github using gh auth login and enter your credentials   
   
3) Maintain /home/$USER/CUDA_NekRS_vars.sh

   Source these variables into your terminal

   . ./CUDA_NekRS_vars.sh

    ... 
    
    currently just set CUDA_HOME, modify LD_LIBRARY_PATH, PATH etc

    may evolve into a family of scripts, or a single script that does everything

5) Install CUDA

    a) Install or update CUDA drivers

    b) Install CUDA toolkit

    https://docs.nvidia.com/cuda/cuda-installation-guide-linux/

    See Install_CUDA_on_Ubuntu.txt for instructions

6) Install ucx

7) Install openmpi

    For both steps I used:

        https://forums.developer.nvidia.com/t/how-to-build-ucx-openmpi-pytorch-with-cuda-distributed-on-agx-orin/341027


    a) We need to install gnu fortran first

    ...

8) Verify everything works so far with successful cuda_samples build

    c) build cuda samples
        
        i) we need glut, vulkan, freeimage, glfw3 libraries first

    ...

9) Install OCCA


10) Finally, install NekRS

