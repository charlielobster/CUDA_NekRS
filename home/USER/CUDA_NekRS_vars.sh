export CUDA_HOME=/usr/local/cuda-13.0
export CUDA_LIB=$CUDA_HOME/lib64

export UCX_HOME=/opt/ucx-1.20.0

export ...



export PATH=$CUDA_HOME/bin:$PATH


export PATH=$CUDA_HOME/bin:$UCX_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_LIB:$LD_LIBRARY_PATH
