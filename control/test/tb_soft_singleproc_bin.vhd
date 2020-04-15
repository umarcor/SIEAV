library vunit_lib;
context vunit_lib.vunit_context;

entity tb_soft_singleproc_bin is
  generic (
    runner_cfg : string;
    tb_path: string
  );
end entity;

library ieee;
context ieee.ieee_std_context;

architecture arch of tb_soft_singleproc_bin is

  constant Ts : time := 20 ms;
  constant cycles : integer := 12 sec / Ts;

  constant Kp : real := 1250.0;

  constant Nd : real := 1.9990e-05;
  constant Dd : real := -0.9990;

begin

  p_main: process
    variable r, e, u, y: real;

    -- File name for saving plant output values
    constant output_filename : string := tb_path & "../soft_singleproc_bin.bin";
    -- Type of the data to be saved in the file
    type real_file is file of real;
    -- Pointer to file
    file fptr : real_file;
    -- Stat of file_open
    variable fstat : file_open_status;
  begin
    test_runner_setup(runner, runner_cfg);
    report "start simulation";
    -- Open the file in write mode, populate the pointer and stat variables
    file_open(fstat, fptr, output_filename, write_mode);
    -- Check that the file was opened successfully
    assert fstat = open_ok report "file_open failed" severity failure;

    y := 0.0;
    r := 10.0;

    for k in 0 to cycles loop
      -- Write current plant output to file
      write(fptr, y);

      e := r-y;
      u := Kp * e;

      y := Nd * u - Dd * y;
    end loop;

    -- Close file
    file_close(fptr);

    report "end of test";
    test_runner_cleanup(runner);
    wait;
  end process;

end arch;
