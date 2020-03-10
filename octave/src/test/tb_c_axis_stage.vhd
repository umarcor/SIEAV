library ieee;
context ieee.ieee_std_context;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.vc_context;
--use vunit_lib.core_pkg.stop;

--use work.pkg_c.all;

entity tb_c_axis_stage is
  generic (
    runner_cfg : string
    --tb_path    : string;
  );
end entity;

architecture test of tb_c_axis_stage is

  constant clk_period : time := 20 ns;
  --constant data_width : natural := get_p(1);
  --constant fifo_depth : natural := get_p(2);

  constant data_width : natural := 32;
  constant fifo_depth : natural := 5;

  constant block_len : natural := 5;

  constant abuf: integer_vector_ptr_t := new_integer_vector_ptr( 3*block_len, extacc, 1);  -- external through access (requires VHPIDIRECT function 'get_string_ptr')

  constant m_axis : axi_stream_master_t := new_axi_stream_master(data_length => data_width);
  constant s_axis : axi_stream_slave_t := new_axi_stream_slave(data_length => data_width);

  signal clk, rst, rstn : std_logic := '0';
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
    variable val, ind: integer;
  begin
    test_runner_setup(runner, runner_cfg);
    info("Init test");
    for x in 0 to block_len-1 loop
      val := get(abuf, x) + 1;
      ind := block_len+x;
      set(abuf, ind, val);
      info("SET " & to_string(ind) & ": " & to_string(val));
    end loop;
    --ibuffer.init(0);
    --obuffer.init(1);
    rst <= '1';
    wait for 16*clk_period;
    rst <= '0';
    --run_test;
    --stop(0);
    info("End test");
    test_runner_cleanup(runner);
    wait;
  end process;

--

  stimuli: process
    variable last : std_logic;
  begin
    sent <= false;
    wait until start and rising_edge(clk);

    --for y in 0 to stream_length-1 loop
      --wait until rising_edge(clk);
      --push_axi_stream(net, m_axis, std_logic_vector(to_signed(ibuffer.get(y), data_width)) , tlast => '0');
    --end loop;

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

    --for y in 0 to stream_length-1 loop
      --pop_axi_stream(net, s_axis, tdata => o, tlast => last);
      --obuffer.set(y,to_integer(signed(o)));
    --end loop;

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
