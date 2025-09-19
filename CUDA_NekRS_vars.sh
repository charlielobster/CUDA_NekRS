# CUDA
export CUDA_HOME=/usr/local/cuda-12.8 # check CUDA Toolkit version and path preference
export CUDA_LIB=$CUDA_HOME/lib64

export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_LIB:$LD_LIBRARY_PATH

# for gdrcopy 
export GDRCOPY_HOME=~/builds/gdrcopy

export PATH=$GDRCOPY_HOME/bin:$PATH
export LD_LIBRARY_PATH=$GDRCOPY_HOME/lib:$LD_LIBRARY_PATH

# for UCX
export UCX_HOME=~/builds/UCX-1.20.0
export UCX_LIB=$UCX_HOME/lib

export UCX_TLS="cuda"
export UCX_NET_DEVICES="wlp5s0" # your nic here

export PATH=$UCX_HOME/bin:$PATH
export LD_LIBRARY_PATH=$UCX_HOME/lib:$LD_LIBRARY_PATH

# for OMPI
export OMPI_HOME=~/builds/openmpi-5.0.8 # can go anywhere
export OMPI_LIB=$OMPI_HOME/lib

export PATH=$OMPI_HOME/bin:$PATH
export LD_LIBRARY_PATH=$OMPI_HOME/lib:$LD_LIBRARY_PATH

# for NekRS
export CC=mpicc
export CXX=mpic++
export FC=mpif77

export NEKRS_HOME=~/builds/NekRS
export PATH=$NEKRS_HOME/bin:$PATH

export PARAVIEW_HOME=~/builds/paraview
export PATH=$PARAVIEW_HOME/bin:$PATH
export LD_LIBRARY_PATH=$PARAVIEW/lib:$LD_LIBRARY_PATH
