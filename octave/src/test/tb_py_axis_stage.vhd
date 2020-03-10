-- This testbench is a Minimum Working Example (MWE) of VUnit's resources to read/write CSV files and to verify
-- AXI4-Stream components. A CSV file that contains comma separated integers is read from 'file_in' and it is
-- sent row by row to an AXI4-Stream Slave. The AXI4-Stream Slave is expected to be connected to an AXI4-Stream
-- Master either directly or (preferredly) through a FIFO, thus composing a loopback. Therefore, as data is
-- pushed to the AXI4-Stream Slave interface, the output is read from the AXI4-Stream Master interface and it
-- is saved to `file_out`.

library ieee;
context ieee.ieee_std_context;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.vc_context;
use vunit_lib.array_pkg.all;

entity tb_py_axis_stage is
  generic (
    runner_cfg : string;
    tb_path    : string;
    file_in    : string := "data/in.csv";
    file_out   : string := "data/out.csv"
  );
end entity;

architecture tb of tb_py_axis_stage is

  constant clk_period : time := 20 ns;
  constant data_width : natural := 32;
  constant fifo_depth : natural := 4;

  constant m_axis : axi_stream_master_t := new_axi_stream_master(data_length => data_width);
  constant s_axis : axi_stream_slave_t := new_axi_stream_slave(data_length => data_width);

  signal clk, rst, rstn : std_logic := '0';
  shared variable m_I, m_O : array_t;
  signal start, sent, saved : boolean := false;

begin

  clk <= not clk after (clk_period/2);
  rstn <= not rst;

  main: process
    procedure run_test is begin
      info("Init test");
      wait until rising_edge(clk); start <= true;
      wait until rising_edge(clk); start <= false;
      wait until (sent and saved and rising_edge(clk));
      info("Test done");
    end procedure;
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop
      if run("test") then
        rst <= '1';
        wait for 15*clk_period;
        rst <= '0';
        run_test;
      end if;
    end loop;
    test_runner_cleanup(runner);
    wait;
  end process;

--

  stimuli: process
    variable last : std_logic;
  begin
    sent <= false;
    wait until start and rising_edge(clk);

    m_I.load_csv(tb_path & file_in);

    info("Sending m_I of size " & to_string(m_I.height) & "x" & to_string(m_I.width) & " to UUT...");

    for y in 0 to m_I.height-1 loop
      for x in 0 to m_I.width-1 loop
        wait until rising_edge(clk);
        if x = m_I.width-1 then last := '1'; else last := '0'; end if;
        push_axi_stream(net, m_axis, std_logic_vector(to_signed(m_I.get(x,y), data_width)) , tlast => last);
      end loop;
    end loop;

    info("m_I sent!");

    wait until rising_edge(clk);
    sent <= true;
    wait;
  end process;

  save: process
    variable o : std_logic_vector(31 downto 0);
    variable last : std_logic:='0';
  begin
    saved <= false;
    wait until start and rising_edge(clk);
    wait for 50*clk_period;

    m_O.init_2d(m_I.width, m_I.height, o'length, true);

    info("Receiving m_O of size " & to_string(m_O.height) & "x" & to_string(m_O.width) & " from UUT...");

    for y in 0 to m_O.height-1 loop
      for x in 0 to m_O.width-1 loop
        pop_axi_stream(net, s_axis, tdata => o, tlast => last);
        if (x = m_O.width-1) and (last='0') then
          error("Something went wrong. Last misaligned!");
        end if;
        m_O.set(x,y,to_integer(signed(o)));
      end loop;
    end loop;

    info("m_O read!");
    wait until rising_edge(clk);
    m_O.save_csv(tb_path & file_out);
    info("m_O saved!");

    wait until rising_edge(clk);
    saved <= true;
    wait;
  end process;

--

  uut_vc: entity work.vc_axis_stage
  generic map (
    m_axis => m_axis,
    s_axis => s_axis,
    data_width => data_width,
    fifo_depth => fifo_depth
  )
  port map (
    clk   => clk,
    rstn  => rstn
  );

end architecture;
