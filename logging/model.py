#!/usr/bin/env python3

# Copyright 2026 Unai Martinez-Corral <unai.martinezcorral@ehu.eus>
#                University of the Basque Country (UPV/EHU) <ehu.eus>
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

from math import (
  sqrt as m_sqrt,
  pi as m_pi
)
from numpy import (
  cos as np_cos,
  sin as np_sin,
  column_stack as np_colstack
)


def model( x, y ):
  """
  Rotate x,y 45º counter-clockwise.
  """
  # https://en.wikipedia.org/wiki/Rotations_and_reflections_in_two_dimensions
  # sin(45º) = cos(45º) = 1/sqrt(2) = sqrt(2)/2
  return (
    (x - y) * m_sqrt(2)/2,
    (x + y) * m_sqrt(2)/2
  )


def gen_test_data( num ):
  """
  Generate a four column matrix with points evenly distributed on the whole circunference and the corresponding result
  of the software model: (x, y, xr, yr).
  """
  arc = (360/num)*m_pi/180
  xy = [(np_cos(ang),np_sin(ang)) for ang in [i*arc for i in range(num)]]
  return np_colstack((xy, [model(val[0], val[1]) for val in xy]))


if __name__ == '__main__':
  test_data = gen_test_data(12)
  # For copying and pasting into the definition of a constant of type 'array of array of real' in VHDL
  for item in test_data:
    print(f"({item[0]} , {item[1]} , {item[2]} , {item[3]}),")
