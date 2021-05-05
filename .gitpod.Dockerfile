FROM gitpod/workspace-full-vnc

USER gitpod

RUN sudo apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive sudo apt-get install -y --no-install-recommends\
   gtkwave \
   libgnat-9 \
   libllvm10 \
 && sudo apt-get autoclean && sudo apt-get clean && sudo apt-get -y autoremove \
 && sudo update-ca-certificates \
 && sudo rm -rf /var/lib/apt/lists/*

# Install extra Python packages
RUN pip3 install -U pip \
 && pip3 install -U pytest

# Install GHDL (nightly LLVM backend)
RUN curl -fsSL https://github.com/ghdl/ghdl/releases/download/nightly/ghdl-gha-ubuntu-20.04-llvm.tgz | \
 sudo tar -xzf - -C /usr/local

# Install VUnit from sources (master branch)
RUN git clone --recurse-submodules https://github.com/VUnit/vunit \
 && cd vunit \
 && python setup.py install \
 && cd .. \
 && rm -rf vunit
