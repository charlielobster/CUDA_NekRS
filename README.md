# Support Documentation for CUDA NekRS Installation on Ubuntu

First, install Ubuntu, without Graphics drivers, to a hard drive and boot into it:

1) Inside your Windows instance, download the Ubuntu 24.04.3 iso file

   Go to https://ubuntu.com/download/desktop and click the green button

2) Note that Balena Etcher stopped working for me after a couple of times, so I switched to Rufus. 
Follow these directions:
  
    https://ubuntu.com/tutorials/create-a-usb-stick-on-windows

3) From your BIOS, boot from the USB drive and install to the target drive

     Leave the "Install latest Graphics and Wifi hardware drivers" unclicked during the install.

     I experienced errors replacing Ubuntu's proprietary GPU drivers. This is required to sync up with the latest CUDA Toolkit libraries. There is a shell fix out there for that issue, but not in this Readme.