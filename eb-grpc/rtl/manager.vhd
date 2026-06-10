library ieee;
context ieee.ieee_std_context;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.vc_context;

entity manager is
  generic (
    g_dat_width : natural := 16;
    g_adr_width : natural := 10
  );
  port (
    CLK       :  in std_logic;
    RST       :  in std_logic;
    WBM_ADR   : out std_logic_vector(g_adr_width-1 downto 0);
    WBM_D     :  in std_logic_vector(g_dat_width-1 downto 0);
    WBM_Q     : out std_logic_vector(g_dat_width-1 downto 0);
    WBM_SEL   : out std_logic_vector(g_dat_width/8 -1 downto 0);
    WBM_CYC   : out std_logic;
    WBM_STB   : out std_logic;
    WBM_WE    : out std_logic;
    WBM_STALL :  in std_logic;
    WBM_ACK   :  in std_logic
  );
end manager;

architecture arch of manager is

  constant bus_handle : bus_master_t := new_bus(
    data_length => g_dat_width,
    address_length => g_adr_width
  );

begin

  p_main: process
    variable tmp : std_logic_vector(WBM_D'range);
  begin
    wait until RST='0' and rising_edge(clk);
    info("start manager test");

    write_bus(net, bus_handle, x"10", x"2211");
    write_bus(net, bus_handle, x"12", x"4433");
    write_bus(net, bus_handle, x"14", x"6655");
    write_bus(net, bus_handle, x"16", x"8877");

    wait for 100 ns;

    read_bus(net, bus_handle, x"10", tmp);
    check_equal(tmp, std_logic_vector'(x"2211"));

    read_bus(net, bus_handle, x"12", tmp);
    check_equal(tmp, std_logic_vector'(x"4433"));

    read_bus(net, bus_handle, x"14", tmp);
    check_equal(tmp, std_logic_vector'(x"6655"));

    read_bus(net, bus_handle, x"16", tmp);
    check_equal(tmp, std_logic_vector'(x"8877"));

    write_bus(net, bus_handle, x"0", x"0000");

    info("manager test finished");
    wait;
  end process;

  wbm_vc : entity vunit_lib.wishbone_master
  generic map (
    bus_handle => bus_handle,
    strobe_high_probability => 1.0
  )
  port map (
    clk   => CLK,
    adr   => WBM_ADR,
    dat_i => WBM_D,
    dat_o => WBM_Q,
    sel   => WBM_SEL,
    cyc   => WBM_CYC,
    stb   => WBM_STB,
    we    => WBM_WE,
    stall => WBM_STALL,
    ack   => WBM_ACK
  );

end;
