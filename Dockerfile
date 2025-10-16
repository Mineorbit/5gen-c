#
# To use, run:
#   docker build -t 5gen-c .
#   docker run -it 5gen-c /bin/bash
#

FROM ubuntu:jammy

RUN apt-get -y update
RUN apt-get -y install software-properties-common
RUN apt-get -y update
RUN apt-get -y install git
RUN apt-get -y install gcc g++
RUN apt-get -y install autoconf libtool make flex bison
RUN apt-get -y install libgmp-dev libmpfr-dev libssl-dev libflint-dev
RUN apt-get -y install perl
RUN apt-get -y install wget libarchive-tools
RUN apt-get -y install z3
RUN apt-get -y install cryptol

#
# Install GHC
#
RUN apt install -y ghc cabal-install
#
# Install yosys
#

WORKDIR /inst
ENV DEBIAN_FRONTEND "noninteractive apt-get autoremove"
RUN apt-get -y install yosys

#
# Install SAW
#

# We need to copy CryptolTC.z3 from the cryptol source repo for saw to work

WORKDIR /inst
RUN git clone https://github.com/GaloisInc/cryptol.git
RUN cd cryptol && git checkout ed757860bf1e39e86fd43262526560b954c9d013
RUN mkdir /root/.cryptol
RUN cp cryptol/lib/CryptolTC.z3 /root/.cryptol

WORKDIR /inst
RUN wget -q https://github.com/GaloisInc/saw-script/releases/download/v0.2/saw-0.2-2016-04-12-Ubuntu14.04-64.tar.gz
RUN tar xf saw-0.2-2016-04-12-Ubuntu14.04-64.tar.gz
ENV PATH "/inst/saw-0.2-2016-04-12-Ubuntu14.04-64/bin:$PATH"

#
# Install Sage
#

WORKDIR /inst
RUN apt-get -y install lbzip2 gfortran
RUN apt-get -y install sagemath

#
# Get 5gen-c repository
#

WORKDIR /inst
RUN git clone https://github.com/Mineorbit/5gen-c.git

WORKDIR /inst/5gen-c
RUN git pull origin master
RUN ./build.sh
