Support scripts and documentation for CUDA NekRS installation on Ubuntu 24.04

1) Maintain /home/$USER/CUDA_NekRS_vars.sh

    ... 
    
    currently just set CUDA_HOME, modify LD_LIBRARY_PATH, PATH etc

    may evolve into a family of scripts, or a single script that does everything

2) Install CUDA

    a) install CUDA drivers

    b) install CUDA toolkit

    https://docs.nvidia.com/cuda/cuda-installation-guide-linux/

3) Install ucx

4) Install openmpi

    For both steps use:

        https://forums.developer.nvidia.com/t/how-to-build-ucx-openmpi-pytorch-with-cuda-distributed-on-agx-orin/341027


    a) We need to install gnu fortran first

    ...

5) Verify everything works so far with successful cuda_samples build

    c) build cuda samples
        
        i) we need glut, vulkan, freeimage, glfw3 libraries first

    ...

6) Install OCCA


7) Finally, install NekRS

