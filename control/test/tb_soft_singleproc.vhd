library vunit_lib;
context vunit_lib.vunit_context;

entity tb_soft_singleproc is
  generic (runner_cfg : string);
end entity;

library ieee;
context ieee.ieee_std_context;

architecture arch of tb_soft_singleproc is

  -- Sample time
  constant Ts : time := 20 ms;
  -- Number of simulation cycles (total sim time / period)
  constant cycles : integer := 12 sec / Ts;

  -- Controller constants
  constant Kp : real := 1250.0;

  -- Plant constants
  constant Nd : real := 1.9990e-05;
  constant Dd : real := -0.9990;

begin

  p_main: process
    -- Reference, error, control and plant output
    variable r, e, u, y: real;
  begin
    test_runner_setup(runner, runner_cfg);
    report "start simulation";
    -- Initial state
    y := 0.0;
    -- Step value
    r := 10.0;

    -- Simulate feedback, controller and plant
    for k in 0 to cycles loop
      e := r-y;
      u := Kp * e;

      y := Nd * u - Dd * y;
    end loop;

    report "end of test";
    test_runner_cleanup(runner);
    wait;
  end process;

end arch;
