# Overwrite this path in case your cuda is installed somewhere else
CUDA_LOCAL_PATH=/usr/local/cuda

# manually specify a g++ binary
#CXX=/usr/local/bin/g++-3.4.2


# set cuda path to /usr in case the CUDA_LOCAL_PATH does not exist
ifeq ($(wildcard ${CUDA_LOCAL_PATH}),)
  CUDA_PATH := /usr
else
  CUDA_PATH := ${CUDA_LOCAL_PATH}
  NVCC ?= ${CUDA_PATH}/bin/nvcc
endif

# pick current g++ in case no CXX override has been specified
CXX ?= $(shell which g++ || echo g++)

# pick current g++ in case no CXX override has been specified
NVCC ?= $(shell which nvcc || echo nvcc)

drv:
	${NVCC} -I${CUDA_PATH}/include -arch=compute_61 -ptx compare.cu -o compare.ptx
	${CXX} -O3 -Wno-unused-result -I${CUDA_PATH}/include -c gpu_burn-drv.cpp
	${CXX} -o gpu_burn gpu_burn-drv.o -O3 -lcuda -L${CUDA_PATH}/lib64 -L${CUDA_PATH}/lib -Wl,-rpath=${CUDA_PATH}/lib64 -Wl,-rpath=${CUDA_PATH}/lib -lcublas -lcudart -o gpu_burn
