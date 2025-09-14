Support scripts and documentation for CUDA NekRS installation on Ubuntu 24.04.3 LTS

First, flash a hard drive with Ubuntu and boot into it

      a) Inside your Windows instance, download the Ubuntu 24.04.3 iso file
      b) Use Balena Etcher to write the iso to the USB drive
      c) From your BIOS, boot from the USB drive and install to the target drive

Next, setup git and github connection

      sudo apt install git         
      sudo apt install gh   
      # login to github using gh auth login and enter your credentials
      git config --global user.email <your email>
      git config --global user.name <your name>

Then, add other optional utilities
   
      sudo snap install --classic code # Visual Studio Code
      sudo apt install timeshift # Timeshift System Recovery

Topology

Generally speaking, these tools need to be configured for CUDA support and built from source

Once inside Ubuntu, create a folder called repos and clone each tool in their respective folders

      mkdir repos
      cd repos
      git clone https://github.com/charlielobster/CUDA_NekRS.git
      git clone https://github.com/openucx/ucx.git
      git clone https://github.com/open-mpi/ompi.git
      git clone https://github.com/libocca/occa.git
      git clone https://github.com/Nek5000/nekRS.git

The topology looks like this:

      /home/USER/
      /home/USER/repos/CUDA_NekRS
      /home/USER/repos/ucx
      /home/USER/repos/ompi
      /home/USER/repos/OCCA
      /home/USER/repos/nekRS
   
Copy the script called 

      cp /home/$USER/CUDA_NekRS_vars.sh $HOME
      cd $HOME

In a terminal, type:

    . ./CUDA_NekRS_vars.sh
       
Use the script before running programs in NekRS.
It performs housekeeping settings like CUDA_HOME, LD_LIBRARY_PATH, PATH etc.
Maybe add to your .profile for terminal initialization.
   
Now, install CUDA development tools

  Install or update CUDA drivers

  Install CUDA toolkit

  https://docs.nvidia.com/cuda/cuda-installation-guide-linux/

  See Install_CUDA_on_Ubuntu.txt for instructions

Install UCX

Install ompi

For both steps I used:

https://forums.developer.nvidia.com/t/how-to-build-ucx-openmpi-pytorch-with-cuda-distributed-on-agx-orin/341027


but before we install ompi, we need to install gnu fortran first

...

Verify everything works (so far) with successful cuda_samples build

  a) we need glut, vulkan, freeimage, glfw3 libraries first

  b) build cuda samples        
  ...

Install OCCA


Finally, we are ready to install NekRS

