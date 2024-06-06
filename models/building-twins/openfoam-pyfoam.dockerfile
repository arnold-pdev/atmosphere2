FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

# based on https://github.com/jakobhaervig/openfoam-dockerfiles
# 1. A docker build command that works inside of models/building-twins: 
#    docker build -f openfoam-pyfoam.dockerfile -t <image-name> .
# 2. A docker run command that works inside of models/building-twins:
#    docker run -it --mount src=$PWD/building-twins/m1_bcs,target=/openfoam,type=bind <image-name>
# Install essential packages and dependencies
RUN apt update && \
    apt install -y sudo software-properties-common wget curl nano git mcedit vim htop build-essential ca-certificates mercurial libboost-all-dev ssh ffmpeg python3 python3-pip

# Add OpenFOAM repository and install OpenFOAM
RUN wget -q -O - http://dl.openfoam.com/add-debian-repo.sh | bash && \
    apt-get update && \
    apt-get install -y openfoam-default
    # alternate versions found using openfoam####-default

# Add user "foam" and give sudo privileges
RUN useradd --user-group --create-home --shell /bin/bash foam && \
    echo "foam ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Source OpenFOAM and fix Docker MPI, set environment variables for foam user
RUN echo "source /usr/lib/openfoam/openfoam/etc/bashrc" >> ~foam/.bashrc && \
    echo "export OMPI_MCA_btl_vader_single_copy_mechanism=none" >> ~foam/.bashrc && \
    sed -i '/export WM_PROJECT_USER_DIR=/cexport WM_PROJECT_USER_DIR="/data/foam-$WM_PROJECT_VERSION"' /usr/lib/openfoam/openfoam/etc/bashrc


# Install pyFoam
RUN pip3 install PyFoam

RUN apt install -y unzip

# Download and compile swak4Foam
# RUN hg clone http://hg.code.sf.net/p/openfoam-extend/swak4Foam /opt/swak4Foam && \
#     cd /opt/swak4Foam && \
#     hg update develop && \
#     ./maintainanceScripts/compileRequirements.sh && \
#     ./AllwmakeAll

# Change user to "foam"
USER foam


