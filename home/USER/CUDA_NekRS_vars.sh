export CUDA_HOME=/usr/local/cuda-13.0
export CUDA_LIB=$CUDA_HOME/lib64

export UCX_HOME=/opt/ucx-1.20.0
export UCX_LIB=$UCX_HOME/lib

export UCX_TLS="cuda"
export UCX_NET_DEVICES="wlp5s0"

export OMPI_HOME=/opt/ompi-5.0.08
export OMPI_LIB=$OMPI_HOME/lib

export PATH=$CUDA_HOME/bin:$UCX_HOME/bin:$OMPI_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_LIB:$UCX_LIB:$OMPI_LIB:$LD_LIBRARY_PATH

