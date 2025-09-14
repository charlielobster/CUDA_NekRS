Support scripts and documentation for CUDA NekRS installation on Ubuntu 24.04.3 LTS

I've tried to make this document self-contained, so although I include links I've used for reference, you shouldn't have to follow them for finding any scripting comands or additional required steps.

First, flash a hard drive with Ubuntu and boot into it

  Inside your Windows instance, download the Ubuntu 24.04.3 iso file

  Go to https://ubuntu.com/download/desktop and click the green button

  Balena Etcher stopped working for me after a couple of times, so I switched to Rufus. Follow these directions:
  
  https://ubuntu.com/tutorials/create-a-usb-stick-on-windows

  From your BIOS, boot from the USB drive and install to the target drive

  In my case, it became necessary to unclick the "Install latest Graphics and Wifi hardware drivers" during the install.
  Apparently I experienced errors replacing Ubuntu's proprietary GPU drivers so that it could sync up with the CUDA Toolkit. 
  There is fix out there for that issue, but I'd rather not add more steps to this Readme.

Now, Install CUDA Toolkit, drivers, and related development tools, taken from these links:

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

Install git and github connection

    sudo apt install git         
    sudo apt install gh         
    # login to github using gh auth login and enter your credentials
    git config --global user.email <your email>
    git config --global user.name <your name>

Then, add other optional utilities
   
    sudo snap install --classic code # Visual Studio Code
    sudo apt install timeshift # Timeshift System Recovery

This is a great time for a Restore Point!

Topology

Create a folder called repos, and clone each tool into their respective subfolders. These tools need to be configured for CUDA support and built from source.

    mkdir repos
    cd repos
    git clone https://github.com/charlielobster/CUDA_NekRS.git
    git clone https://github.com/openucx/ucx.git
    git clone https://github.com/open-mpi/ompi.git
    git clone https://github.com/NVIDIA/cuda-samples.git
    git clone https://github.com/libocca/occa.git
    git clone https://github.com/Nek5000/nekRS.git
      
Copy the script /CUDA_NekRS/home/USER/CUDA_NekRS_vars.sh to your own home directory, and source it

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

Install UCX

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

Install openmpi

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

Verify everything links and works (so far) with a successful cuda_samples build

To fully build all the samples for our target OS, we need a few more libraries first:

    sudo apt install cmake
    sudo apt install freeglut3-dev libfreeimage-dev libglfw3-dev
    sudo apt install vulkan-tools

Now build the samples        

    mkdir build && cd build
    cmake ..
    make -j$(nproc)

The binaries can be found in the build folder's Samples subfolder


Install OCCA



Finally, we are ready to install NekRS


