-- Copyright 2026 Unai Martinez-Corral <unai.martinezcorral@ehu.eus>
--                University of the Basque Country (UPV/EHU) <ehu.eus>
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- SPDX-License-Identifier: Apache-2.0

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_rotation is
  generic (runner_cfg : string);
end entity;

architecture tb of tb_rotation is
begin
  main : process
  begin
    test_runner_setup(runner, runner_cfg);
    report "Rotation testbench!";
    test_runner_cleanup(runner);
  end process;
end architecture;
