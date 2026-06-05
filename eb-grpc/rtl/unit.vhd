library ieee;
context ieee.ieee_std_context;

library vunit_lib;
context vunit_lib.vc_context;

entity unit is
  generic (
    g_dat_width : natural := 16;
    g_adr_width : natural := 10
  );
  port (
    CLK       :  in std_logic;
    WBS_ADR   :  in std_logic_vector(g_adr_width-1 downto 0);
    WBS_D     :  in std_logic_vector(g_dat_width-1 downto 0);
    WBS_Q     : out std_logic_vector(g_dat_width-1 downto 0);
    WBS_SEL   :  in std_logic_vector(g_dat_width/8 -1 downto 0);
    WBS_CYC   :  in std_logic;
    WBS_STB   :  in std_logic;
    WBS_WE    :  in std_logic;
    WBS_STALL : out std_logic;
    WBS_ACK   : out std_logic
  );
end unit;

architecture arch of unit is

  constant memory : memory_t := new_memory;
  constant buf : buffer_t := allocate(memory, 2**g_adr_width);
  constant wbs : wishbone_slave_t := new_wishbone_slave(
    memory => memory,
    ack_high_probability => 1.0,
    stall_high_probability => 0.0
  );

begin

  wbs_vc : entity vunit_lib.wishbone_slave
  generic map (
    wishbone_slave => wbs
  )
  port map (
    clk   => clk,
    adr   => WBS_ADR,
    dat_i => WBS_D,
    dat_o => WBS_Q,
    sel   => WBS_SEL,
    cyc   => WBS_CYC,
    stb   => WBS_STB,
    we    => WBS_WE,
    stall => WBS_STALL,
    ack   => WBS_ACK
  );

end;
