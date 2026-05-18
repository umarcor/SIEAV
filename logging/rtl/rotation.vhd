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

-- pragma synthesis_off
library vunit_lib;
context vunit_lib.vunit_context;
-- pragma synthesis_on

entity rotation is
  generic (
    -- pragma synthesis_off
    g_logger : logger_t := null_logger;
    -- pragma synthesis_on
    g_precision : natural := 15
  );
  port (
    CLK : in  std_logic;
    RST : in  std_logic;
    XI  : in  real;
    YI  : in  real;
    XO  : out real;
    YO  : out real
  );
end entity;

architecture arch of rotation is

  signal xs, ys, xr, yr : signed(g_precision downto 0) := (others=>'0');

begin

  -- pragma synthesis_off
  process(CLK)
    type model_t is array(0 to 1) of real;
    variable expected : model_t := ( 0.0, 0.0 );

    function model ( x,y : real ) return model_t is
      constant const : real := sqrt(2.0)/2.0;
    begin
      return ( (x-y)*const , (x+y)*const );
    end function;

    constant max_diff : real := 5.65e-3;

    variable xe,ye : real := 0.0;
  begin
    if rising_edge(CLK) and RST='0' then
      info(g_logger, "UUT OUT " & to_string(XO) &":"& to_string(YO));
      info(g_logger, "MODEL " & to_string(expected(0)) &":"& to_string(expected(1)));
      check_equal(XO, expected(0), "X!", max_diff => max_diff);
      check_equal(YO, expected(1), "Y!", max_diff => max_diff);
      info(g_logger, "UUT IN " & to_string(XI) &":"& to_string(YI));
      expected := model(XI,YI);
    end if;
  end process;
  -- pragma synthesis_on

  types: block is
    constant scale : real := (2.0**g_precision)-1.0;
  begin
    xs <= to_signed(integer( XI * scale ), xs'length);
    ys <= to_signed(integer( YI * scale ), ys'length);
    XO <= real(to_integer(xr))/scale;
    YO <= real(to_integer(yr))/scale;
  end block;

  process(CLK)
    variable xmy, xpy : signed(g_precision+1 downto 0) := (others=>'0');
  begin
    if rising_edge(CLK) then
      if RST then
        xr <= (others=>'0');
        yr <= (others=>'0');
      else
        xmy := resize(xs, xmy'length) - ys;
        xpy := resize(xs, xpy'length) + ys;
        -- K = .5 + .25 - .125 + .0625                     = .6875   (2.77%) 4 shifts 3 adders
        -- K = .5 + .25                - .03125            = .71875  (1.65%) 5 shifts 2 adders
        -- K = .5 + .25                - .03125 - 0.015625 = .703125 (0.56%) 6 shifts 3 adders
        xr <= resize( (shift_right(xmy, 1) + shift_right(xmy, 2)) - (shift_right(xmy, 5) + shift_right(xmy, 6)) , xr'length);
        yr <= resize( (shift_right(xpy, 1) + shift_right(xpy, 2)) - (shift_right(xpy, 5) + shift_right(xpy, 6)) , yr'length);
      end if;
    end if;
  end process;

end architecture;
