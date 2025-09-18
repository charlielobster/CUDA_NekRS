export CUDA_HOME=/usr/local/cuda-12.8 # check CUDA Toolkit version and paths
export CUDA_LIB=$CUDA_HOME/lib64

export UCX_HOME=/opt/UCX-1.20.0
export UCX_LIB=$UCX_HOME/lib

export UCX_TLS="cuda"
export UCX_NET_DEVICES="wlp5s0" # your nic here

export OMPI_HOME=/opt/openmpi-5.0.8 # can go anywhere
export OMPI_LIB=$OMPI_HOME/lib

export OCCA_HOME=/opt/occa # not sure we want or need this
export OCCA_LIB=$OCCA_HOME/lib

export PATH=$CUDA_HOME/bin:$UCX_HOME/bin:$OMPI_HOME/bin:$OCCA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_LIB:$UCX_LIB:$OMPI_LIB:$OCCA_LIB:$LD_LIBRARY_PATH

export CC=mpicc
export CXX=mpic++
export FC=mpif77

export NEKRS_HOME=$HOME/builds/nekRS/JezSw/nekrs
export PATH=$NEKRS_HOME/bin:$PATH

