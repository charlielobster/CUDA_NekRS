Support scripts and documentation for CUDA NekRS installation on Ubuntu 24.04.3 LTS

First, flash a hard drive with Ubuntu and boot into it

  a) Inside your Windows instance, download the Ubuntu 24.04.3 iso file

  Go to https://ubuntu.com/download/desktop and click the green button

  b) Use Rufus or Balena Etcher to write the iso to the USB drive. Note that I tried Balena but it stopped working after a couple of times, so I switched to Rufus.
  
  https://etcher.balena.io/#download-etcher
  
  https://ubuntu.com/tutorials/create-a-usb-stick-on-windows

  c) From your BIOS, boot from the USB drive and install to the target drive

Setup required libraries
       
       sudo apt install gcc
       sudo apt install gfortran

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

Once inside Ubuntu, create a folder called repos, and clone each tool into their respective subfolders. These tools need to be configured for CUDA support and built from source.

      mkdir repos
      cd repos
      git clone https://github.com/charlielobster/CUDA_NekRS.git
      git clone https://github.com/openucx/ucx.git
      git clone https://github.com/open-mpi/ompi.git
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
      /home/USER/repos/OCCA
      /home/USER/repos/nekRS
      
Use the script before running programs in NekRS. It performs housekeeping settings for CUDA_HOME, PATH, LD_LIBRARY_PATH etc. Maybe add to your .profile for terminal initialization. 

Now, install CUDA development tools, taken from this link:

https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=24.04&target_type=deb_local
    
      wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin
      sudo mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600
      wget https://developer.download.nvidia.com/compute/cuda/13.0.1/local_installers/cuda-repo-ubuntu2404-13-0-local_13.0.1-580.82.07-1_amd64.deb
      sudo dpkg -i cuda-repo-ubuntu2404-13-0-local_13.0.1-580.82.07-1_amd64.deb
      sudo cp /var/cuda-repo-ubuntu2404-13-0-local/cuda-*-keyring.gpg /usr/share/keyrings/
      sudo apt-get update
      sudo apt-get -y install cuda-toolkit-13-0



https://docs.nvidia.com/cuda/cuda-installation-guide-linux/

First verify a few steps from that document, starting with Section 3. This Readme assumes a remote repository installation method. In the link above, Ubuntu instructions begin at section 4.8.
      
4.8.3. Install or update CUDA drivers via 

      wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb\
      sudo dpkg -i cuda-keyring_1.1-1_all.deb
      sudo apt install cuda-toolkit
      sudo apt install nvidia-gds

This creates a folder containing the CUDA 13.0 contents called /usr/local/cuda-13.0

Install CUDA toolkit
      
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

