FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

# Install essential packages and dependencies, including sudo
RUN apt update && \
    apt install -y sudo software-properties-common wget curl nano git htop build-essential ca-certificates mercurial libboost-all-dev ssh ffmpeg python3 python3-pip

RUN useradd --user-group --create-home --shell /bin/bash -G sudo foam

# Add OpenFOAM repository and install OpenFOAM
RUN wget -q -O - http://dl.openfoam.com/add-debian-repo.sh | bash && \
    apt-get update && \
    apt-get install -y openfoam-default

# Install pyFoam
RUN pip3 install PyFoam

# Download and compile swak4Foam
RUN hg clone http://hg.code.sf.net/p/openfoam-extend/swak4Foam /opt/swak4Foam && \
    cd /opt/swak4Foam && \
    ./maintainanceScripts/compileRequirements.sh && \
    ./Allwmake

# Add user "foam" and give sudo privileges
RUN apt install -y sudo && \
    useradd --user-group --create-home --shell /bin/bash foam && \
    echo "foam ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Source OpenFOAM and fix Docker MPI, set environment variables for foam user
RUN echo "source /usr/lib/openfoam/openfoam/etc/bashrc" >> /home/foam/.bashrc && \
    echo "export OMPI_MCA_btl_vader_single_copy_mechanism=none" >> /home/foam/.bashrc && \
    sed -i '/export WM_PROJECT_USER_DIR=/cexport WM_PROJECT_USER_DIR=\"/data/foam-$WM_PROJECT_VERSION\"' /usr/lib/openfoam/openfoam/etc/bashrc

# Change user to "foam"
USER foam
