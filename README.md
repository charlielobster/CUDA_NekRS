# Support Documentation for CUDA NekRS Installation on Ubuntu

### Install Ubuntu 24.04.3 to a hard drive and boot into it.

1) Inside your Windows instance, download the Ubuntu 24.04.3 iso file

   Go to https://ubuntu.com/download/desktop and click the green button

2) Use Rufus (or Ventoy for multi-image usb sticks). Follow these directions:
  
    https://ubuntu.com/tutorials/create-a-usb-stick-on-windows

3) From your BIOS, boot from the USB drive and install to the target drive

     If you are running a newer GPU, leave the "Install latest Graphics and Wifi hardware drivers" unclicked during the install.

### Install CUDA Drivers (if not Present) and CUDA Toolkit

If you are unsure if you need a CUDA Driver or you just want to know what Driver and CUDA Version you have, type:

    nvidia-smi

If you have a driver, you'll get back something like this:

    +-----------------------------------------------------------------------------------------+
    | NVIDIA-SMI 570.172.08             Driver Version: 570.172.08     CUDA Version: 12.8     |
    |-----------------------------------------+------------------------+----------------------+
    | GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
    |                                         |                        |               MIG M. |

Here you can see my Driver Version is 570.172.08 and my CUDA Version is 12.8. Driver Version maps also to Device Version

In a terminal, type:

    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
    sudo dpkg -i cuda-keyring_1.1-1_all.deb
    sudo apt update