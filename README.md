Support scripts and documentation for CUDA NekRS installation on Ubuntu 24.04.3 LTS

UPDATE 9/15 - This Readme is still in progress. While I am able to compile NekRS without issue now, I'm unable to run any NekRS samples without fatally crashing. The most recent error is a call to OpenMPI (MPI_WaitAll) inside 3rd_party/gslib/ogs/oogs.cpp, so I am trying to recompile ompi with better error handling, and suspect my OMPI build flags. It's also clear to me now that I shouldn't use the latest Nvidia drivers for this because one of the tools in NekRS's 3rd_party is configuring for compute_70, which is no longer found in CUDA Toolkit 13, so I might need to go back to 11.

NekRS is a large project with many moving parts written for a different computing topology than a traditional laptop or pc. This Readme documents the process and progress of installing its required tools for this new OS and topology. The tools appear to require build configuration for CUDA support so I am focusing on building them from source when possible. I don't know if that is necessary in every case. Overall, it seems the best way to get up to speed with any troubleshooting efforts.

I've tried to make this document self-contained, so although I will mention links I've used for reference, it isn't necessary to follow them for additional required steps unless explicitly stated.

First, install Ubuntu, without Graphics drivers, to a hard drive and boot into it:

1) Inside your Windows instance, download the Ubuntu 24.04.3 iso file

   Go to https://ubuntu.com/download/desktop and click the green button

2) Note that Balena Etcher stopped working for me after a couple of times, so I switched to Rufus. 
Follow these directions:
  
    https://ubuntu.com/tutorials/create-a-usb-stick-on-windows

3) From your BIOS, boot from the USB drive and install to the target drive

     Leave the "Install latest Graphics and Wifi hardware drivers" unclicked during the install.

     I experienced errors replacing Ubuntu's proprietary GPU drivers. This is required to sync up with the latest CUDA Toolkit libraries. There is a shell fix out there for that issue, but not in this Readme.

Second, install CUDA Toolkit, drivers, and related development tools, taken from these links:

https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=24.04&target_type=deb_local

https://docs.nvidia.com/cuda/cuda-installation-guide-linux/

    
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin
    sudo mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600
    wget https://developer.download.nvidia.com/compute/cuda/13.0.1/local_installers/cuda-repo-ubuntu2404-13-0-local_13.0.1-580.82.07-1_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu2404-13-0-local_13.0.1-580.82.07-1_amd64.deb
    sudo cp /var/cuda-repo-ubuntu2404-13-0-local/cuda-*-keyring.gpg /usr/share/yrings/
    sudo apt-get update
    sudo apt-get -y install cuda-toolkit-13-0
    # install open drivers
    sudo apt-get install -y nvidia-open
    reboot

This creates a folder called /usr/local/cuda-13.0. Then,
      
    sudo apt install nvidia-gds

Optionally, install git and github connection

    sudo apt install git         
    sudo apt install gh         
    # login to github using gh auth login and enter your credentials
    git config --global user.email <your email>
    git config --global user.name <your name>

Optionally, add other utilities
   
    sudo snap install --classic code # Visual Studio Code
    sudo apt install timeshift # Timeshift System Recovery

This is a great time for a Restore Point. I include my user files.

Topology

Create a folder called repos, and clone each tool into their respective subfolders. 

    mkdir repos
    cd repos
    git clone https://github.com/charlielobster/CUDA_NekRS.git # optional, only contains Readme and shell script
    git clone https://github.com/openucx/ucx.git
    git clone https://github.com/open-mpi/ompi.git
    git clone https://github.com/NVIDIA/cuda-samples.git
    git clone https://github.com/libocca/occa.git
    git clone https://github.com/Nek5000/nekRS.git
      
Optionally, copy the script /CUDA_NekRS/home/USER/CUDA_NekRS_vars.sh to your own home directory, and source it

    cd $HOME
    cp /repos/CUDA_NekRS/home/USER/CUDA_NekRS_vars.sh $HOME
    . ./CUDA_NekRS_vars.sh       

The topology looks like this:

    /home/USER/CUDA_NekRS_vars.sh
    /home/USER/repos/CUDA_NekRS
    /home/USER/repos/ucx
    /home/USER/repos/ompi
    /home/USER/repos/cuda-samples
    /home/USER/repos/OCCA
    /home/USER/repos/nekRS
      
Use the script before running programs in NekRS. It performs housekeeping settings for CUDA_HOME, PATH, LD_LIBRARY_PATH etc. Maybe add to your .profile for terminal initialization. 

Third, install UCX

    cd repos/ucx
    sudo apt install -y autoconf automake libtool m4 \
           libnuma-dev hwloc libhwloc-dev
    ./autogen.sh
    ./configure --prefix=$UCX_HOME \
            --with-cuda=$CUDA_HOME \
            --enable-mt              \
            --disable-assertions     \
            --disable-debug \
            --disable-params-check
    make -j6
    sudo make install

Fourth, install openmpi

For both UCX and openmpi steps, I used this link:

https://forums.developer.nvidia.com/t/how-to-build-ucx-openmpi-pytorch-with-cuda-distributed-on-agx-orin/341027

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
    make -j6
    sudo make install

This is another good time for a Restore Point.

Fourth, verify everything links and works (so far) with a successful cuda_samples build

To fully build all the samples for our target OS, we need a few more libraries first:

    sudo apt install cmake
    sudo apt install freeglut3-dev libfreeimage-dev libglfw3-dev
    sudo apt install vulkan-tools glslc spriv-tools glslang-tools

Now build the samples        

    cd repos/cuda-samples
    mkdir build && cd build
    cmake ..
    make -j$(nproc)

The binaries can be found in the build folder's Samples subfolder

Fourth, install OCCA

    cd repos/occa
    ./configure-cmake.sh
    cmake --build build
    sudo cmake --install build --prefix $OCCA_HOME

The build failed at first. I made two small changes to the OCCA codebase. I enabled FORTRAN by default which isn't necessary, and in internal/modes/cuda/utils.cpp, I commented out two OCCA_CUDA_ERROR statements on lines 188 and 218, because I got a conversion errors there during the build (probably a CUDA version upgrade issue). So, we don't get debug output for those two events now, but the trade-off (repair the build) is worth it, in the short term.

Fifth, install NekRS

Recall I had made two small changes to the OCCA codebase. The conversion issue upgrading to newer drivers appears worse when I try the NekRS 3rd_Party codebase. I replaced the 3rd_Party/occa subfolder with my working copy of the tool, and got a successful build that way. In general, clone my forked copy of any repo to use my changes.

From the nekRS Readme,

    cd repos/nekRS
    CC=mpicc CXX=mpic++ FC=mpif77 ./nrsconfig [-DCMAKE_INSTALL_PREFIX=$HOME/.local/nekrs]

The first time I ran it, I received:

    CMake Error: CMAKE_C_COMPILER not set, after EnableLanguage
    CMake Error: CMAKE_CXX_COMPILER not set, after EnableLanguage
    CMake Error: CMAKE_Fortran_COMPILER not set, after EnableLanguage

This requires passing the paths to cmake in the command-line or using a set() before the call to project(). So these must be set with the path to mpicc etc, starting on line 3 in NekRS's top-level CMakeLists.txt:

    set(CMAKE_CXX_COMPILER,"$ENV{OMPI_HOME}/bin")
    set(CMAKE_C_COMPILER, "$ENV{OMPI_HOME}/bin") 
    set(CMAKE_Fortran_COMPILER, "$ENV{OMPI_HOME}/bin") 

I am able then to compile the NekRS tool to 100% completion, but the samples are still broken. In line 193 of 3rd_Party/gslib/oogs.cpp, the following line throws a segmentation fault in regards to permissions to a memory location.
   
    MPI_CHECK(MPI_Waitall(pwd->comm[send].n + pwd->comm[recv].n, pwd->req, MPI_STATUSES_IGNORE));
