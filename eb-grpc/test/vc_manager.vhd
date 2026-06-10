library ieee;
context ieee.ieee_std_context;

library vunit_lib;
context vunit_lib.vunit_context;

entity vc_manager is
  generic (
    g_request   : queue_t;
    g_response  : queue_t;
    g_dat_width : natural := 16;
    g_adr_width : natural := 10
  );
  port (
    CLK  :  in std_logic;
    RST  :  in std_logic;
    DONE : out std_logic
  );
end vc_manager;

architecture arch of vc_manager is

  signal wb_adr   : std_logic_vector(g_adr_width-1 downto 0);
  signal wb_m2s   : std_logic_vector(g_dat_width-1 downto 0);
  signal wb_s2m   : std_logic_vector(g_dat_width-1 downto 0);
  signal wb_sel   : std_logic_vector(g_dat_width/8 -1 downto 0);
  signal wb_cyc   : std_logic;
  signal wb_stb   : std_logic;
  signal wb_we    : std_logic;
  signal wb_stall : std_logic;
  signal wb_ack   : std_logic;

begin

  uut_manager: entity work.manager
  generic map (
    g_dat_width => g_dat_width,
    g_adr_width => g_adr_width
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
    WBM_ACK   => wb_ack
  );

  vc_wbs2q: entity work.wbs2q
  generic map (
    g_request => g_request,
    g_response => g_response,
    g_header => 16,
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
    WBS_ACK   => wb_ack,
    DONE      => DONE
  );

end;
