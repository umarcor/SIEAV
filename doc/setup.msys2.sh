#!/usr/bin/env sh

# Authors:
#   Unai Martinez-Corral
#
# Copyright 2020-2021 Unai Martinez-Corral <unai.martinezcorral@ehu.eus>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

set -e

# Update the MSYS2 installation (sync repos and install newer packages)
pacman -Syu --noconfirm

# Install the dependencies for simulation and synthesis of VHDL is FLOSS tools
pacman -S --noconfirm p7zip git \
    mingw-w64-"${MSYSTEM_CARCH}"-yosys \
    mingw-w64-"${MSYSTEM_CARCH}"-gtkwave \
    mingw-w64-"${MSYSTEM_CARCH}"-python-pip \
    mingw-w64-"${MSYSTEM_CARCH}"-python-setuptools \
    mingw-w64-"${MSYSTEM_CARCH}"-python-wheel

if [ -d vunit ]; then
  printf "\033[31mSubdir 'vunit' exists already.\033[0m\n"
  printf "\033[31mPlease, remove it and run this script again.\033[0m\n"
  exit 1
fi

# Install VUnit from sources (master branch)
git clone --recurse-submodules https://github.com/VUnit/vunit
cd vunit
python setup.py install

# Test that the installation of the tools was succesful
cd examples/vhdl/array_axis_vcs
python run.py -v

# On an environment with an screen, GTKWave can be executed:
if [ -z "$CI" ]; then
  python run.py -v -g
fi
