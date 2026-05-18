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

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_rotation is
  generic (runner_cfg : string);
end entity;

architecture tb of tb_rotation is

  constant clk_period : time := 10 ns;

  signal clk, rst : std_logic := '0';

  signal x, y, xr, yr : real := 0.0;

  -- Logging
  constant logger : logger_t := get_logger("logger");
  constant file_handler : log_handler_t := new_log_handler(
    output_path(runner_cfg) & "logger.csv",
    format => csv
    --use_color => false
  );

begin

  clk <= not clk after clk_period/2;

  process
  begin
    set_log_handlers(logger, (display_handler, file_handler));
    show_all(logger, file_handler);
    show_all(logger, display_handler);
    rst <= '1', '0' after clk_period*10;
    wait;
  end process;

  UUT: entity work.rotation
  generic map (
    g_logger => logger
  )
  port map (
    CLK => clk,
    RST => rst,
    XI  => x,
    YI  => y,
    XO  => xr,
    YO  => yr
  );

  main : process

    type titem_t is array(0 to 3) of real;
    type tarray_t is array (natural range <>) of titem_t;
    constant test_data : tarray_t := (
      (  1.0 ,                    0.0 ,                 0.7071067811865476 ,  0.7071067811865476 ), -- 0
      (  0.8660254037844387 ,     0.5 ,                 0.2588190451025209 ,  0.9659258262890683 ), -- 30
      (  0.5 ,                    0.8660254037844386 , -0.2588190451025207 ,  0.9659258262890684 ), -- 60
      (  0.0 ,                    1.0 ,                -0.7071067811865475 ,  0.7071067811865476 ), -- 90
      ( -0.5 ,                    0.8660254037844387 , -0.9659258262890682 ,  0.2588190451025210 ), --120
      ( -0.8660254037844385 ,     0.5 ,                -0.9659258262890684 , -0.2588190451025204 ), -- 150
      ( -1.0 ,                    0.0 ,                -0.7071067811865477 , -0.7071067811865475 ), -- 180
      ( -0.8660254037844388 ,    -0.5 ,                -0.2588190451025211 , -0.9659258262890683 ), -- 210
      ( -0.5 ,                   -0.8660254037844384 ,  0.2588190451025203 , -0.9659258262890684 ), -- 240
      (  0.0 ,                   -1.0 ,                 0.7071067811865475 , -0.7071067811865477 ), -- 270
      (  0.5 ,                   -0.866025403784439 ,   0.9659258262890682 , -0.2588190451025215 ), -- 300
      (  0.8660254037844384 ,    -0.5 ,                 0.9659258262890684 ,  0.2588190451025203 )  -- 330
    );

    variable xe, ye : real;
    constant max_diff : real := 1.0e-15;

  begin

    test_runner_setup(runner, runner_cfg);
    set_stop_level(failure);
    info("Rotation testbench!");

    wait until rising_edge(clk) and rst='0';
    info(logger, "RST went down!");

    for i in test_data'range loop
      x  <= test_data(i)(0);
      y  <= test_data(i)(1);
      xe := test_data(i)(2);
      ye := test_data(i)(3);

      info(logger, "TEST [" & to_string(i) &"] "& to_string(x) &":"& to_string(y) &" | "& to_string(xe) &":"& to_string(ye) );

      wait until rising_edge(clk);

      -- FIXME!
      -- These passed when the software model was executed in this same process, but started failing when the UUT was added.
      -- Since the same software model does work when executed in the UUT, the problem here is probably timing/registering,
      -- rather than a numerical error.
      check_equal(xr, xe, "X!", max_diff => max_diff);
      check_equal(yr, ye, "Y!", max_diff => max_diff);

    end loop;

    test_runner_cleanup(runner);

  end process;

end architecture;
