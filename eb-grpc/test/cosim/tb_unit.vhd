library ieee;
context ieee.ieee_std_context;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_unit is
  generic (
    runner_cfg  : string;
    g_dat_width : natural := 16;
    g_adr_width : natural := 10
  );
end tb_unit;

architecture arch of tb_unit is

  constant clk_period : time := 10 ns;

  signal clk : std_logic := '0';

  signal wb_adr   : std_logic_vector(g_adr_width-1 downto 0);
  signal wb_m2s   : std_logic_vector(g_dat_width-1 downto 0);
  signal wb_s2m   : std_logic_vector(g_dat_width-1 downto 0);
  signal wb_sel   : std_logic_vector(g_dat_width/8 -1 downto 0);
  signal wb_cyc   : std_logic;
  signal wb_stb   : std_logic;
  signal wb_we    : std_logic;
  signal wb_stall : std_logic;
  signal wb_ack   : std_logic;

  signal done : std_logic;

begin

  clk <= not clk after clk_period/2;

  p_main: process
  begin
    test_runner_setup(runner, runner_cfg);
    info("start of simulation");
    wait until done;
    info("end of simulation");
    test_runner_cleanup(runner);
    wait;
  end process;
  test_runner_watchdog(runner, 10 ms);


  vc_grpc2wbm: entity work.grpc2wbm
  generic map (
    g_dat_width => g_dat_width,
    g_adr_width => g_adr_width
  )
  port map (
    CLK       => clk,
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
    g_dat_width => g_dat_width,
    g_adr_width => g_adr_width
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
