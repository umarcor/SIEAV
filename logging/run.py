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

from pathlib import Path
from textwrap import dedent
from vunit import VUnit

ROOT = Path(__file__).parent

vu = VUnit.from_argv()
vu.add_vhdl_builtins()
vu.enable_location_preprocessing()

vu.add_library("lib").add_source_files([
  ROOT / "rtl/*.vhd",
  ROOT / "test/*.vhd"
])

def post_func(results):
  report = results.get_report()
  print("\nTest output path:", report.output_path / 'test_output')
  for key, test in report.tests.items():
    print(dedent(f"""
    Test <{key}> {test.status} in {test.time} sec.
    relpath: {test.relpath}\
    """))
    logger_csv = test.path / 'logger.csv'
    if not logger_csv.exists() :
      raise Exception ("logger CSV file not found!")

vu.main(post_run=post_func)
