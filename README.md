Support scripts and documentation for CUDA NekRS installation on Ubuntu 24.04.3 LTS

0) Flash a hard drive with Ubuntu, then boot into it

   a) Find a hard drive you don't care about erasing

   b) Start with a USB drive containing the etched iso

       i) On your windows box, download the 24.04.3 iso file

       ii) Use Balena Etcher to write the iso to the USB drive

       iii) Boot into your BIOS and boot from the USB drive

           Install to the right drive!

1) Some additional software:

    sudo apt install git

    sudo apt install gh

    % login to github using gh auth login and entering my credentials   
   
3) Maintain /home/$USER/CUDA_NekRS_vars.sh

    ... 
    
    currently just set CUDA_HOME, modify LD_LIBRARY_PATH, PATH etc

    may evolve into a family of scripts, or a single script that does everything

4) Install CUDA

    a) Install or update CUDA drivers

    b) Install CUDA toolkit

    https://docs.nvidia.com/cuda/cuda-installation-guide-linux/

    See Install_CUDA_on_Ubuntu.txt for instructions

5) Install ucx

6) Install openmpi

    For both steps I used:

        https://forums.developer.nvidia.com/t/how-to-build-ucx-openmpi-pytorch-with-cuda-distributed-on-agx-orin/341027


    a) We need to install gnu fortran first

    ...

7) Verify everything works so far with successful cuda_samples build

    c) build cuda samples
        
        i) we need glut, vulkan, freeimage, glfw3 libraries first

    ...

8) Install OCCA


9) Finally, install NekRS

