FROM ubuntu:22.04
# can use "openfoam" for my FROM line
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y software-properties-common
RUN apt install -y wget

# install essentials
RUN apt-get update 
RUN apt-get install -y rsync
RUN apt-get install -y ssh
RUN apt-get install -y curl
RUN apt-get install -y nano
RUN apt-get install -y git
RUN apt-get install -y htop
RUN apt-get install -y build-essential
RUN apt-get install -y software-properties-common
RUN apt-get install -y ca-certificates
RUN apt-get install -y mercurial
RUN apt-get update

		
# install useful openfoam tools
RUN apt-get install -y ffmpeg

# download openfoam and update repos
RUN wget -q -O - http://dl.openfoam.com/add-debian-repo.sh | bash
RUN apt-get update

# install latest openfoam
RUN apt-get install -y openfoam-default

# add user "foam"
RUN useradd --user-group --create-home --shell /bin/bash foam ;\
	echo "foam ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
    
# source openfoam and fix docker mpi
RUN echo "source /usr/lib/openfoam/openfoam/etc/bashrc" >> ~foam/.bashrc ;\
   echo "export OMPI_MCA_btl_vader_single_copy_mechanism=none" >> ~foam/.bashrc

# change environmental variables to make sure $WM_PROJECT_USER_DIR is outside of the container
RUN sed -i '/export WM_PROJECT_USER_DIR=/cexport WM_PROJECT_USER_DIR="/data/foam-$WM_PROJECT_VERSION"' /usr/lib/openfoam/openfoam/etc/bashrc

# change user to "foam"
USER foam
