library vunit_lib;
context vunit_lib.vunit_context;

entity tb_soft_twoproc_bin is
  generic (
    runner_cfg : string;
    tb_path: string
  );
end entity;

library ieee;
context ieee.ieee_std_context;

architecture arch of tb_soft_twoproc_bin is

  constant Ts : time := 20 ms;
  constant cycles : integer := 12 sec / Ts;

  constant r : real := 10.0;

  signal clk, rst : std_logic := '1';
  signal u, y : real := 0.0;

begin

  clk <= not clk after Ts/2;

  p_main: process
    variable r, e: real := 0.0;

    constant output_filename : string := tb_path & "../soft_twoproc_bin.bin";
    type real_file is file of real;
    file fptr : real_file;
    variable fstat : file_open_status;
  begin
    test_runner_setup(runner, runner_cfg);
    report "start simulation";

    rst <= '1';
    wait for 5*Ts;
    rst <= '0';

    file_open(fstat, fptr, output_filename, write_mode);
    assert fstat = open_ok report "file_open failed" severity failure;

    for k in 0 to cycles loop
      wait for Ts;
      write(fptr, y);
    end loop;

    file_close(fptr);

    report "end of test";
    test_runner_cleanup(runner);
    wait;
  end process;

  p_controller: process(clk)
    constant Kp : real := 1250.0;
    variable e : real := 0.0;
  begin
    if rising_edge(clk) then
      if rst = '1' then
        u <= 0.0;
      else
        e := r-y;
        u <= Kp * e;
      end if;
    end if;
  end process;

  p_plant: process(clk)
    constant Nd : real := 1.9990e-05;
    constant Dd : real := -0.9990;
  begin
    if rising_edge(clk) then
      if rst = '1' then
        y <= 0.0;
      else
        y <= Nd * u - Dd * y;
      end if;
    end if;
  end process;

end arch;
