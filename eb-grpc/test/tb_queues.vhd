library ieee;
context ieee.ieee_std_context;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.vc_context;

entity tb_queues is
  generic (
    runner_cfg : string
  );
end tb_queues;

architecture arch of tb_queues is

  constant clk_period : time := 10 ns;

  signal clk : std_logic := '0';
  signal rst : std_logic := '1';

  constant c_dat_width : natural := 16;
  constant c_adr_width : natural := 10;

  signal mdone, udone : std_logic;

  constant request  : queue_t := new_queue;
  constant response : queue_t := new_queue;

begin

  clk <= not clk after clk_period/2;

  p_main: process
  begin
    test_runner_setup(runner, runner_cfg);
    show(com_logger, display_handler, trace);
    report "start simulation";
    rst <= '1';
    wait for clk_period*10;
    rst <= '0';
    wait for clk_period;
    wait until mdone and udone;
    info("end of simulation");
    test_runner_cleanup(runner);
  end process;
  test_runner_watchdog(runner, 1 ms);

  vc_manager: entity work.vc_manager
  generic map (
    g_request => request,
    g_response => response,
    g_dat_width => c_dat_width,
    g_adr_width => c_adr_width
  )
  port map (
    CLK  => clk,
    RST  => rst,
    DONE => mdone
  );

  vc_unit: entity work.vc_unit
  generic map (
    g_request => request,
    g_response => response,
    g_dat_width => c_dat_width,
    g_adr_width => c_adr_width
  )
  port map (
    CLK => clk,
    DONE => udone
  );

end;
