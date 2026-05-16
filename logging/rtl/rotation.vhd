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

library ieee;
context ieee.ieee_std_context;
use ieee.math_real.sqrt;

entity rotation is
  port (
    clk : in  std_logic;
    rst : in  std_logic;
    xi  : in  real;
    yi  : in  real;
    xr  : out real;
    yr  : out real
  );
end entity;

architecture arch of rotation is
begin

  process(clk)
  begin
    if rising_edge(clk) then
      if rst then
        xr <= 0.0;
        yr <= 0.0;
      else
        xr <= (xi-yi) * sqrt(2.0)/2.0;
        yr <= (xi+yi) * sqrt(2.0)/2.0;
      end if;
    end if;
  end process;

end architecture;
