# Support Documentation for CUDA NekRS Installation on Ubuntu

Welcome to some CUDA NekRS support! Test specs are RTX 3090 Ti GPUs, i9-12900KS chipset on an ASUS Z690 motherboard. These steps should work with most gaming and laptop PCs with an Nvidia GPU.

### 1. Install Ubuntu 24.04.3

1) Inside your Windows instance, download the Ubuntu 24.04.3 iso file

   Go to https://ubuntu.com/download/desktop and click the green button

2) Use Rufus (or Ventoy for multi-image usb sticks). Follow these directions:
  
    https://ubuntu.com/tutorials/create-a-usb-stick-on-windows

3) From your BIOS, boot from the USB drive and install to the target drive

    You may choose "Install latest Graphics and Wifi hardware drivers" during the install, but it may be safer not to. There is a separate set of instructions later if you don't (I chose a manual install). 

### 2. Install CUDA Drivers (if not pesent) and CUDA Toolkit (under version 13.0)

1. If you are unsure if or what Driver and CUDA Version you have, open a terminal and type:

        nvidia-smi

    If you have a one, you'll get back something like:

       +-----------------------------------------------------------------------------------------+
       | NVIDIA-SMI 570.172.08             Driver Version: 570.172.08     CUDA Version: 12.8     |
       |-----------------------------------------+------------------------+----------------------+
       | GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
       | Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
       |                                         |                        |               MIG M. |
       ...

    In the example, Driver Version is 570.172.08 and CUDA Version is 12.8.

    There is a difference between CUDA Version and Toolkit Version, even though they are usually the same numbers on given machine. The CUDA Version relates to the driver software you have running on a particular GPU device. Your CUDA Toolkit Version determines what hardware architectures a codebase on your machine may target. 

    Parts of the NekRS codebase target the compute-70 (CUDA Version 7) architecture. However, the lowest the Version 13 Toolkit will go down to is CUDA Version 7.5. So, we need a CUDA Toolkit Version below 13 to successfully build NekRS with minimal changes to the code.

2. In a terminal, type:

       wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
       sudo dpkg -i cuda-keyring_1.1-1_all.deb
       sudo apt update

    a. If you chose to install your drivers separately, then type

        sudo apt-get install -y nvidia-driver-580-open # this version is just the latest for 9/18/25
        sudo apt-get install -y cuda-drivers-580

    b. or just,

        sudo apt-get install -y cuda-drivers

3. If you have one type of GPU device, and it is running CUDA Version 13 or higher, the command to "apt install cuda-toolkit" will automatically install the Version 13 CUDA Toolkit as well. Nvidia ended targeting devices below CUDA Versions 7.5 for this, their latest Toolkit. So if your driver's CUDA Version is 13, do this:

        sudo apt install cuda-toolkit-12-8 # 12.9 probably works too
   
   If you have a Driver Version < 13, you should just get an older version of the Toolkit cabable of targeting your device. Just type:
    
        sudo apt install cuda-toolkit 

### 3. Folder Topology

Create a folder called repos, and clone each tool into their respective subfolders. 

    mkdir repos && builds
    cd repos
    git clone https://github.com/NVIDIA/gdrcopy.git
    git clone https://github.com/openucx/UCX.git
    git clone --resursive https://github.com/open-mpi/ompi.git
    git clone --recursive https://gitlab.kitware.com/paraview/paraview.git
    git clone https://github.com/JezSw/NekRS.git  # using JezSw's recent version


The topology changes:

    ~/repos/gdrcopy
    ~/repos/UCX
    ~/repos/ompi
    ~/repos/paraview
    ~/repos/NekRS

Once everything is installed:

    ~/builds/gdrcopy
    ~/builds/NekRS
    ~/builds/paraview
    ~/builds/openmpi-5.0.8
    ~/builds/UCX-1.20.0      

### 4. Environment Variables

Let's define all the environment variables first in a script and source that script to make use of them in our build statements, then later before running programs in NekRS. 
      
1. Review the CUDA_NekRS_vars.sh script in this repo. Verify the CUDA Toolkit path. Find your wifi nic with a call to "ip a". 

        ip a 
        # open CUDA_NekRS_vars.sh in Text Editor
        # collect your nic add it to the script 

2. Double-check CUDA Toolkit Version and path preferences. Then, source the script.

        # double-check Toolkit Version and paths, then source the changes
        # cd to the folder containing CUDA_NekRS_var.sh
        . ./CUDA_NekRS_vars.sh     

4. This printenv command:

        printenv | grep -E "CUDA|UCX|OMPI|PATH"

   should return these variables:

        GDRCOPY_HOME=~/builds/grdcopy
        OMPI_HOME=~/builds/openmpi-5.0.8
        UCX_NET_DEVICES=<your nic>
        UCX_LIB=~/builds/UCX-1.20.0/lib
        UCX_HOME=~/builds/UCX-1.20.0
        OMPI_LIB=~/builds/openmpi-5.0.8/lib
        CUDA_LIB=/usr/local/cuda-12.8/lib64
        LD_LIBRARY_PATH=/usr/local/cuda-12.8/lib64:~/builds/UCX-1.20.0/lib:~/builds/openmpi-5.0.8/lib:
        UCX_TLS=cuda
        CUDA_HOME=/usr/local/cuda-12.8
        NEKRS_HOME=~/builds/NekRS
        PATH=/usr/local/cuda-12.8/bin:~/builds/UCX-1.20.0/bin:~/builds/openmpi-5.0.8/bin:...
        ...

   Or add its contents to your .bashrc for terminal initialization. If your edit lives in ~/repo/CUDA_NekRS, type this:

        echo . ~/repos/CUDA_NekRS/CUDA_NekRS_vars.sh >> ~/.bashrc


### 5. (Optional) Install gdrcopy

This tool facilitates shared memory between applications and CUDA at the UCX layer

    cd repos/gdrcopy
    make prefix=$GDRCOPY_HOME all install
    sudo ./insmod.sh

### 6. Install UCX

    cd repos/ucx
    sudo apt install -y autoconf automake libtool m4 \
           libnuma-dev hwloc libhwloc-dev
    ./autogen.sh
    ./configure --prefix=$UCX_HOME \
            --with-cuda=$CUDA_HOME \
            --with-gdrcopy=$GDRCOPY_HOME \ # remove this line if gdrcopy is not installed
            --enable-mt              
    make -j$(nproc)
    sudo make install

### 7. Install Open MPI

First we need to install gnu fortran, Flex, and zlib:
       
    sudo apt install gfortran
    sudo apt install flex
    sudo apt install zlib1g-dev liblz4-dev libzstd-dev

Then,

    cd repos/ompi
    sudo mkdir $OMPI_HOME
    ./autogen.pl
    ./configure --prefix=$OMPI_HOME \
        --with-cuda=$CUDA_HOME \
        --with-ucx=$UCX_HOME \
        --with-ucx-libdir=$UCX_LIB \
        --with-cuda-libdir=$CUDA_LIB/stubs 
    make --j$(nproc)
    sudo make install

### 8. Install NekRS

1) If not using CUDA_NekRS_vars.sh, export the NekRS path to CUDA_NekRS_vars.sh:

       export NEKRS_HOME=~/builds/NekRS
       export PATH=$NEKRS_HOME/bin:$PATH

2) Install,

       cd repos/NekRS
       cmake -S . -B build -Wfatal-errors -DCMAKE_INSTALL_PREFIX=$NEKRS_HOME
       cmake --build ./build --target install -j$(nproc)

### 9. Get NekRS Output

1) Navigate to the build's examples/turbPipePeriodic folder:

       cd $NEKRS_HOME/examples/turbPipePeriodic

2) The nekRS example .par files are not set up to save any output. 

    In turbPipe.par, change the endTime from 200 to .5 for a shorter test time. 

       endTime = .5 

3) Then, starting at line 8, add these lines to the turbPipe.par file:

        writeControl = steps
        writeInterval = 6 

4) Then,
    
        mpirun -np 2 nekrs --setup turbPipe.par

### 10. Install Paraview

A few required libraries we haven't installed yet:

    sudo apt-get install git libgl1-mesa-dev \
                libxt-dev libqt5x11extras5-dev \
                libqt5help5 qttools5-dev \
                qtxmlpatterns5-dev-tools libqt5svg5-dev \
                python3-numpy libtbb-dev \
                ninja-build qtbase5-dev \
                qtchooser qt5-qmake qtbase5-dev-tools

And install:

    mkdir ~/builds/paraview
    cd ~/builds/paraview
    cmake -GNinja \
        -DPARAVIEW_USE_MPI=ON \
        -DVTK_SMP_IMPLEMENTATION_TYPE=TBB \
        -DCMAKE_BUILD_TYPE=Release ~/repos/paraview
    ninja -j $(nproc)

## Examples Video Results

### TurbPipePeriodic

https://github.com/user-attachments/assets/fbdb9a18-5268-4801-aea3-33f470e5ad2a

NekRS Examples Playlist: https://www.youtube.com/playlist?list=PLya1SvGKk6YahaFk3HIyiFsJiURsulj2r

# REFERENCES

https://github.com/Nek5000

https://developer.nvidia.com/cuda-toolkit-archive

https://docs.nvidia.com/cuda/cuda-installation-guide-linux/

https://developer.nvidia.com/cuda-gpus

https://en.wikipedia.org/wiki/CUDA

https://forums.developer.nvidia.com/t/how-to-build-ucx-openmpi-pytorch-with-cuda-distributed-on-agx-orin/341027

https://docs.open-mpi.org/en/v5.0.x/tuning-apps/networking/cuda.html

https://stackoverflow.com/questions/28932864/which-compute-capability-is-supported-by-which-cuda-versions/28933055#28933055

# NOTES

If your instance of Nvidia Visual Profiler is currently busted,

<img src="images/Profiler_Error.png" />

Type this:

    sudo apt install openjdk-8-jdk

Go to your CUDA_HOME/bin folder and edit the nvvp file. Add the following before '$@' at the end of the file:

    -vm /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
