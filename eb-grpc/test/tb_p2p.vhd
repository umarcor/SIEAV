library ieee;
context ieee.ieee_std_context;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.vc_context;

entity tb_p2p is
  generic (
    runner_cfg : string
  );
end tb_p2p;

architecture arch of tb_p2p is

  constant clk_period : time := 10 ns;

  signal clk : std_logic := '0';
  signal rst : std_logic := '1';

  constant c_dat_width : natural := 16;
  constant c_adr_width : natural := 10;

  signal wb_adr   : std_logic_vector(c_adr_width-1 downto 0);
  signal wb_m2s   : std_logic_vector(c_dat_width-1 downto 0);
  signal wb_s2m   : std_logic_vector(c_dat_width-1 downto 0);
  signal wb_sel   : std_logic_vector(c_dat_width/8 -1 downto 0);
  signal wb_cyc   : std_logic;
  signal wb_stb   : std_logic;
  signal wb_we    : std_logic;
  signal wb_stall : std_logic;
  signal wb_ack   : std_logic;
  signal done     : std_logic;

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
    wait until done;
    report "end of test";
    test_runner_cleanup(runner);
  end process;
  test_runner_watchdog(runner, 1 ms);


  uut_manager: entity work.manager
  generic map (
    g_dat_width => c_dat_width,
    g_adr_width => c_adr_width
  )
  port map (
    CLK       => clk,
    RST       => rst,
    WBM_ADR   => wb_adr,
    WBM_D     => wb_s2m,
    WBM_Q     => wb_m2s,
    WBM_SEL   => wb_sel,
    WBM_CYC   => wb_cyc,
    WBM_STB   => wb_stb,
    WBM_WE    => wb_we,
    WBM_STALL => wb_stall,
    WBM_ACK   => wb_ack,
    DONE      => done
  );


  uut_unit: entity work.unit
  generic map (
    g_dat_width => c_dat_width,
    g_adr_width => c_adr_width
  )
  port map (
    CLK       => clk,
    WBS_ADR   => wb_adr,
    WBS_D     => wb_m2s,
    WBS_Q     => wb_s2m,
    WBS_SEL   => wb_sel,
    WBS_CYC   => wb_cyc,
    WBS_STB   => wb_stb,
    WBS_WE    => wb_we,
    WBS_STALL => wb_stall,
    WBS_ACK   => wb_ack
  );

end;
