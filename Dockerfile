#https://www.tensorflow.org/get_started/os_setup#optional_install_cuda_gpus_on_linux

#Dockerfile to build singularity container that can run on IU BigRed2

FROM nvidia/cuda:7.5-cudnn5-devel-centos7

MAINTAINER Soichi Hayashi <hayashis@iu.edu>

#java8/wheel/pip/pip-wheel is just for bazel (what a mess!)
RUN yum install -y git python-devel java-1.8.0-openjdk-devel wget which unzip tkinter && \
    yum install -y epel-release && \
    yum install -y python-pip && pip install --upgrade pip && \
    pip install wheel numpy matplotlib && \
    yum clean all

#Installing bazel (after all that, I still need to download this thing..)
RUN wget https://github.com/bazelbuild/bazel/releases/download/0.4.4/bazel-0.4.4-installer-linux-x86_64.sh && \
    chmod +x bazel-0.4.4-installer-linux-x86_64.sh && \
    ./bazel-0.4.4-installer-linux-x86_64.sh && \
    rm bazel-0.4.4-installer-linux-x86_64.sh

#set ENV parameters we need to build / configure. without this, prompt cause docker build to fail
ENV CAPABILITY=3.5 \
    CC_OPT_FLAGS=-march=native \
    COMPUTE_CAPABILITIES=3.5 \
    CUDA_DNN_LIB_ALT_PATH=libcudnn.so \
    CUDA_DNN_LIB_PATH=lib64/libcudnn.so \
    CUDA_RT_LIB_PATH=lib64/libcudart.so \
    CUDA_TOOLKIT_PATH=/usr/local/cuda \
    CUDNN_INSTALL_PATH=/usr/local/cuda-7.5 \
    GCC_HOST_COMPILER_PATH=/usr/bin/gcc \
    GEN_GIT_SOURCE=tensorflow/tools/git/gen_git_source.py \
    USE_DEFAULT_PYTHON_LIB_PATH=1 \
    PYTHON_BIN_PATH=/usr/bin/python \
    SOURCE_BASE_DIR=/src \
    PLATFORM=linux \
    TF_CUDA_COMPUTE_CAPABILITIES=3.5 \
    TF_CUDA_VERSION=7.5 \
    TF_CUDNN_VERSION=5 \
    TF_CUDA_EXT= \
    TF_CUDNN_EXT= \
    TF_ENABLE_XLA=0 \
    TF_NEED_CUDA=1 \
    TF_NEED_GCP=0 \
    TF_NEED_HDFS=0 \
    TF_NEED_JEMALLOC=1 \
    TF_NEED_OPENCL=0

#download tensorflow and build it
RUN git clone https://github.com/tensorflow/tensorflow /src && \
    cd /src && \
    ./configure && \
    bazel build -c opt --copt=-mavx --copt=-msse4.2 --config=cuda //tensorflow/tools/pip_package:build_pip_package && \
    bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg && \
    pip install /tmp/tensorflow_pkg/* && \
    rm -rf /tmp/tensorflow_pkg && \
    rm -rf /src

#where nvidia driver will be mounted (for singularity)
RUN mkdir -p /opt/cray/nvidia/
ENV LD_LIBRARY_PATH=/opt/cray/nvidia/352.68-1_1.0502.2451.1.1.gem/lib64

#TODO - make this container testable by me..
#RUN mkdir -p /N/u/hayashis/BigRed2 && 
RUN mkdir -p /N/u /N/home /N/soft /N/dc2 



