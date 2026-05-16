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
    logger : logger_t := null_logger;
    -- pragma synthesis_on
    precision : natural := 15
  );
  port (
    clk : in  std_logic;
    rst : in  std_logic;
    xi  : in  real;
    yi  : in  real;
    xo  : out real;
    yo  : out real
  );
end entity;

architecture arch of rotation is

  signal xs, ys, xr, yr : signed(precision downto 0) := (others=>'0');

begin

  -- pragma synthesis_off
  sim: block is
    signal xp,yp : real := 0.0;
  begin
    process(clk)

      type model_t is array(0 to 1) of real;
      variable model_coords : model_t;

      function model ( x,y : real ) return model_t is
        constant const : real := sqrt(2.0)/2.0;
      begin
        return ( (x-y)*const , (x+y)*const );
      end function;

      constant max_diff : real := 5.65e-3;

    begin
      if rising_edge(clk) and rst='0' then
        xp <= xi;
        yp <= yi;
        info(logger, "UUT " & to_string(xp) &":"& to_string(yp) &" | "& to_string(xr) &":"& to_string(yr) );
        model_coords := model(xp,yp);
        info(logger, "MODEL " & to_string(model_coords(0)) &":"& to_string(model_coords(1)));
        check_equal(xo, model_coords(0), "X!", max_diff => max_diff);
        check_equal(yo, model_coords(1), "Y!", max_diff => max_diff);
      end if;
    end process;
  end block;
  -- pragma synthesis_on

  types: block is
    constant scale : real := (2.0**precision)-1.0;
  begin
    xs <= to_signed(integer( xi * scale ), xs'length);
    ys <= to_signed(integer( yi * scale ), ys'length);
    xo <= real(to_integer(xr))/scale;
    yo <= real(to_integer(yr))/scale;
  end block;

  process(clk)
    variable xmy, xpy : signed(precision+1 downto 0) := (others=>'0');
  begin
    if rising_edge(clk) then
      if rst then
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
