Support scripts and documentation for the CUDA NekRS installation on Ubuntu 24.04

1) maintain /home/$USER/cuda_nekrs_env_vars.sh

... set CUDA_HOME, modify LD_LIBRARY_PATH, PATH etc

2) install cuda

    a) install cuda drivers

    b) install cuda toolkit

    https://docs.nvidia.com/cuda/cuda-installation-guide-linux/

3) install ucx

4) install openmpi

    a) We need to install gnu fortran first

...

5) verify everything works with cuda_samples

    c) build cuda samples
        
        i) we need glut, vulkan, freeimage, glfw3 libraries