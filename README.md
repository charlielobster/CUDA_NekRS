# Support Documentation for CUDA NekRS Installation on Ubuntu

### 1. Install Ubuntu 24.04.3 to a hard drive and boot into it.

1) Inside your Windows instance, download the Ubuntu 24.04.3 iso file

   Go to https://ubuntu.com/download/desktop and click the green button

2) Use Rufus (or Ventoy for multi-image usb sticks). Follow these directions:
  
    https://ubuntu.com/tutorials/create-a-usb-stick-on-windows

3) From your BIOS, boot from the USB drive and install to the target drive

     If you are running a newer GPU, leave the "Install latest Graphics and Wifi hardware drivers" unclicked during the install.

### 2. Install CUDA Drivers (if not Present) and CUDA Toolkit (Under Version 13.0)

If you are unsure if or what Driver and CUDA Version you have, open a terminal and type:

    nvidia-smi

If you have a one, you'll get back something like:

    +-----------------------------------------------------------------------------------------+
    | NVIDIA-SMI 570.172.08             Driver Version: 570.172.08     CUDA Version: 12.8     |
    |-----------------------------------------+------------------------+----------------------+
    | GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
    |                                         |                        |               MIG M. |
    ...
In the example, Driver Version is 570.172.08 and CUDA Version is 12.8. This is good, anything under v13.0 is not a problem. 

Let me attempt to clarify a very murky subject here. There is a difference between CUDA Version and Toolkit Version, even though they are usually the same numbers. The CUDA Version relates to the driver software you have running a particular GPU device on your machine. Meanwhile, your CUDA Toolkit's Version determines what hardware architectures your codebase can target. The NekRS codebase targets the compute-70 (CUDA Version 7.0) architecture in some sections. So, we need a CUDA Toolkit under Version 13.0 to successfully build to that target with minimal changes to the code. 

In a terminal, type:

    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
    sudo dpkg -i cuda-keyring_1.1-1_all.deb
    sudo apt update

If you have a Driver Version < v13.0, just type:
    
    sudo apt install cuda-toolkit


However, if you have a Driver Version 13, apt install will automatically think you want the Version 13.0 CUDA Toolkit as well (which is incorrect!)

So if your driver's CUDA Version is 13 or higher, do this instead:

    sudo apt install cuda-toolkit-12-8

### 3. Folder Topology

Create a folder called repos, and clone each tool into their respective subfolders. 

    mkdir repos
    cd repos
    git clone https://github.com/openucx/ucx.git
    git clone https://github.com/open-mpi/ompi.git
    git clone https://github.com/libocca/occa.git
    git clone --recursive https://gitlab.kitware.com/paraview/paraview.git

Create a separate top-level folder for multiple copies of nekRS:
    
    mkdir nekRS && cd nekRS
    mkdir nek5000 && cd nek5000
    git clone https://github.com/Nek5000/nekRS.git
    cd .. && mkdir JezSw && cd JezSw
    git clone https://github.com/JezSw/nekRS.git  

The topology changes:

    /home/USER/repos/ucx
    /home/USER/repos/ompi
    /home/USER/repos/OCCA
    /home/USER/repos/nekRS/nek5000/nekRS
    /home/USER/repos/nekRS/JezSw/nekRS

Once everything is installed:

    /home/USER/builds/nekRS/nek5000/nekRS
    /home/USER/builds/nekRS/JezSw/nekRS
    /home/USER/builds/paraview
    /opt/openmpi-5.0.8
    /opt/UCX-1.20.0
    /opt/occa
      

### 4. Environment Variables
      
Optionally, copy the script /CUDA_NekRS/home/USER/CUDA_NekRS_vars.sh from this repo to your own home directory, Check the CUDA Toolkit path first, and also find your wifi nic with a call to "ip a". Then, source it. 

    cd $HOME
    cp /repos/CUDA_NekRS/home/USER/CUDA_NekRS_vars.sh $HOME
    . ./CUDA_NekRS_vars.sh     

And the following printenv command:

    printenv | grep -E "CUDA|OCCA|UCX|OMPI|PATH"

should return these variables:

    OMPI_HOME=/opt/openmpi-5.0.8
    OCCA_LIB=/opt/occa/lib
    UCX_NET_DEVICES=<your nic>
    UCX_LIB=/opt/ucx-1.20.0/lib
    ...
    UCX_HOME=/opt/ucx-1.20.0
    OMPI_LIB=/opt/openmpi-5.0.8/lib
    CUDA_LIB=/usr/local/cuda-12.8/lib64
    LD_LIBRARY_PATH=/usr/local/cuda-12.8/lib64:/opt/ucx-1.20.0/lib:/opt/openmpi-5.0.8/lib:/opt/occa/lib:
    UCX_TLS=cuda
    CUDA_HOME=/usr/local/cuda-12.8
    PATH=/usr/local/cuda-12.8/bin:/opt/ucx-1.20.0/bin:/opt/openmpi-5.0.8/bin:/opt/occa/:...
    OCCA_HOME=/opt/occa

Use the script before running programs in NekRS, or add its contents to your .profile for terminal initialization. 

### 5. Install UCX

    cd repos/ucx
    sudo apt install -y autoconf automake libtool m4 \
           libnuma-dev hwloc libhwloc-dev
    ./autogen.sh
    ./configure --prefix=$UCX_HOME \
            --with-cuda=$CUDA_HOME \
            --with-gdrcopy=/usr/local/ \
            --enable-mt              
    make -j$(nprocs)
    sudo make install


### 6. Install Open MPI

Before we can install openmpi, we need to install gnu fortran, Flex, and zlib:
       
    sudo apt install gfortran
    sudo apt install flex
    sudo apt install zlib1g-dev liblz4-dev libzstd-dev

    cd repos/ompi
    sudo mkdir $OMPI_HOME
    git submodule update --init --recursive
    ./autogen.pl
    ./configure --prefix=$OMPI_HOME \
        --with-cuda=$CUDA_HOME \
        --with-ucx=$UCX_HOME \
        --with-ucx-libdir=$UCX_LIB \
        --with-cuda-libdir=$CUDA_LIB \
        --enable-mpirun-prefix-by-default
    make --j$(nprocs)
    sudo make install

### 7. Install OCCA (possibly optional)

Install cmake

    sudo apt install cmake

Then

    cd repos/occa
    ./configure-cmake.sh
    cmake --build build
    sudo cmake --install build --prefix $OCCA_HOME

### 8. Install NekRS (in progress)

1) Try Nek5000's version:

    From the nekRS Readme,

       cd repos/nekRS/nek5000/nekRS
       cmake -S . -B build -Wfatal-errors -DCMAKE_INSTALL_PREFIX=$HOME/builds/nek5000/nekrs

2) Try JezSw's version:

       cd repos/nekRS/JezSw/nekRS
       cmake -S . -B build -Wfatal-errors -DCMAKE_INSTALL_PREFIX=$HOME/builds/nek5000/nekrs

    This one worked for me!

### 9. Get NekRS Output!

The nekRS example .par files are not set up to save any output. 
Add these lines, starting at line xx to the turbPipePeriodic.par file:

    writeCondition = tt
    writeInterval = xx

### 10. Install Paraview

    mkdir $HOME/builds/paraview
    cd $HOME/builds/paraview
    cmake -GNinja -DPARAVIEW_USE_PYTHON=ON -DPARAVIEW_USE_MPI=ON -DVTK_SMP_IMPLEMENTATION_TYPE=TBB -DCMAKE_BUILD_TYPE=Release ../../repos/paraview
    ninja

