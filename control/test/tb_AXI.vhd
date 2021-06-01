library ieee;
context ieee.ieee_std_context;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.vc_context;

entity tb_AXI is
  generic (
    runner_cfg : string
  );
end entity;

architecture arch of tb_AXI is

  -- AXI-Lite interface

  constant c_axi_aclk       : time := 5 ns;
  constant c_axi_data_width : integer := 16;
  constant c_axi_addr_width : integer := 4;

  signal axi_aclk    : std_logic := '0';
  signal axi_aresetn : std_logic;
  signal axi_awaddr  : std_logic_vector(c_axi_addr_width-1 downto 0);
  signal axi_awprot  : std_logic_vector(2 downto 0);
  signal axi_awvalid : std_logic;
  signal axi_awready : std_logic;
  signal axi_wdata   : std_logic_vector(c_axi_data_width-1 downto 0);
  signal axi_wstrb   : std_logic_vector((c_axi_data_width/8)-1 downto 0);
  signal axi_wvalid  : std_logic;
  signal axi_wready  : std_logic;
  signal axi_bresp   : std_logic_vector(1 downto 0);
  signal axi_bvalid  : std_logic;
  signal axi_bready  : std_logic;
  signal axi_araddr  : std_logic_vector(c_axi_addr_width-1 downto 0);
  signal axi_arprot  : std_logic_vector(2 downto 0);
  signal axi_arvalid : std_logic;
  signal axi_arready : std_logic;
  signal axi_rdata   : std_logic_vector(c_axi_data_width-1 downto 0);
  signal axi_rresp   : std_logic_vector(1 downto 0);
  signal axi_rvalid  : std_logic;
  signal axi_rready  : std_logic;

  constant bus_handle : bus_master_t := new_bus(
    data_length    => axi_wdata'length,
    address_length => axi_awaddr'length
  );

  -- System clock, reset and enables

  constant c_clk : time := 5 ns;

  signal clk : std_logic := '0';
  signal rst : std_logic := '0';
  signal en_c, en_p: std_logic;

  -- System I/O

  signal plant_i : std_logic_vector(7 downto 0) := (others=>'0');
  signal plant_o : std_logic_vector(7 downto 0) := (others=>'0');

  -- Procedure for running the test WITHOUT foreign functions/procedures
  procedure simTest(
    signal net : inout network_t
  ) is
    variable tmp : std_logic_vector(axi_rdata'range);

  begin

    write_bus(net, bus_handle, x"0", x"2211");
    write_bus(net, bus_handle, x"2", x"4433");
    write_bus(net, bus_handle, x"4", x"6655");
    write_bus(net, bus_handle, x"6", x"8877");

    wait for 25*c_clk;

    read_bus(net, bus_handle, x"0", tmp);
    check_equal(tmp, std_logic_vector'(x"2211"), "read data");

    read_bus(net, bus_handle, x"2", tmp);
    check_equal(tmp, std_logic_vector'(x"4433"), "read data");

    read_bus(net, bus_handle, x"4", tmp);
    check_equal(tmp, std_logic_vector'(x"6655"), "read data");

    read_bus(net, bus_handle, x"6", tmp);
    check_equal(tmp, std_logic_vector'(x"8877"), "read data");

    wait for 50 us;

    write_bus(net, bus_handle, x"0", x"5555");

    wait for 100 us;
  end procedure;

  -- Procedure for running the test WITH foreign functions/procedures
  procedure cosimTest(
    signal net : inout network_t
  ) is

    type params_t is array (0 to 3) of real;
    type params_acc_t is access params_t;

    impure function getParamsPtr return params_acc_t is
    begin report "VHPIDIRECT getParamsPtr" severity failure; end;
    attribute foreign of getParamsPtr : function is "VHPIDIRECT libcaux.so getParamsPtr";

    variable params : params_acc_t := getParamsPtr;

    procedure handleInterrupt is
    begin report "VHPIDIRECT handleInterrupt" severity failure; end;
    attribute foreign of handleInterrupt : procedure is "VHPIDIRECT libcaux.so handleInterrupt";

    variable tmp : std_logic_vector(axi_wdata'length-1 downto 0);

    use work.fixed_pkg.to_sfixed;
    use work.fixed_pkg.to_slv;

  begin

    -- Double/real parameters retrieved from C are converted to 16 bit std_logic_vectors
    -- (then, sent to the AXI-Lite VCs through the bus handle)

    tmp := to_slv(to_sfixed(params(0), 11, -4));
    info("Ref: " & to_string(tmp) & " " & to_string(params(0)));
    write_bus(net, bus_handle, x"0", tmp);

    tmp := to_slv(to_sfixed(params(1), 2, -13));
    info("Kp:  " & to_string(tmp) & " " & to_string(params(1)));
    write_bus(net, bus_handle, x"2", to_slv(to_sfixed(params(1), 2, -13)));

    tmp := to_slv(to_sfixed(params(2), 2, -13));
    info("Ki:  " & to_string(tmp) & " " & to_string(params(2)));
    write_bus(net, bus_handle, x"4", to_slv(to_sfixed(params(2), 2, -13)));

    tmp := to_slv(to_sfixed(params(3), 2, -13));
    info("Kd:  " & to_string(tmp) & " " & to_string(params(3)));
    write_bus(net, bus_handle, x"6", to_slv(to_sfixed(params(3), 2, -13)));

    -- Call the foreign interrupt handle routine once every 100 us, 6 times
    for x in 0 to 5 loop
      wait for 100 us;
      handleInterrupt;

      -- After each call to the interrupt handle routine, update the Ref

      tmp := to_slv(to_sfixed(params(0), 11, -4));
      info("Ref: " & to_string(tmp) & " " & to_string(params(0)));
      write_bus(net, bus_handle, x"0", tmp);
    end loop;

  end procedure;

begin

  p_main: process
  begin
    test_runner_setup(runner, runner_cfg);
    report "start simulation";

    rst <= '1';
    wait for 5*c_clk;
    rst <= '0';

    while test_suite loop
      if run("cosim") then
        cosimTest(net);
      elsif run("sim") then
        simTest(net);
      end if;
    end loop;

    report "end of test";
    test_runner_cleanup(runner);
  end process;
  test_runner_watchdog(runner, 1 ms);

  vc_axi: entity vunit_lib.axi_lite_master
  generic map (
    bus_handle => bus_handle
  )
  port map (
    aclk    => axi_aclk,
    arready => axi_arready,
    arvalid => axi_arvalid,
    araddr  => axi_araddr,
    rready  => axi_rready,
    rvalid  => axi_rvalid,
    rdata   => axi_rdata,
    rresp   => axi_rresp,
    awready => axi_awready,
    awvalid => axi_awvalid,
    awaddr  => axi_awaddr,
    wready  => axi_wready,
    wvalid  => axi_wvalid,
    wdata   => axi_wdata,
    wstrb   => axi_wstrb,
    bvalid  => axi_bvalid,
    bready  => axi_bready,
    bresp   => axi_bresp
  );

  -- The Design, the entity/component which is to be synthesised at the end of the development
  uut: entity work.DesignTop
  port map (
    CONTROLLER_CLK => clk,
    CONTROLLER_EN  => en_c,

    AXI_S_ACLK    => axi_aclk,
    AXI_S_ARESETN => (not rst),
    AXI_S_AWADDR  => axi_awaddr,
    AXI_S_AWPROT  => axi_awprot,
    AXI_S_AWVALID => axi_awvalid,
    AXI_S_AWREADY => axi_awready,
    AXI_S_WDATA   => axi_wdata,
    AXI_S_WSTRB   => axi_wstrb,
    AXI_S_WVALID  => axi_wvalid,
    AXI_S_WREADY  => axi_wready,
    AXI_S_BRESP   => axi_bresp,
    AXI_S_BVALID  => axi_bvalid,
    AXI_S_BREADY  => axi_bready,
    AXI_S_ARADDR  => axi_araddr,
    AXI_S_ARPROT  => axi_arprot,
    AXI_S_ARVALID => axi_arvalid,
    AXI_S_ARREADY => axi_arready,
    AXI_S_RDATA   => axi_rdata,
    AXI_S_RRESP   => axi_rresp,
    AXI_S_RVALID  => axi_rvalid,
    AXI_S_RREADY  => axi_rready,

    PLANT_I => plant_i,
    PLANT_O => plant_o
  );

  -- Simulation model of the plant, the hardware outside of the FPGA
  -- (might include modelling actuators and/or capture devices)
  i_plant: entity work.plant
  port map (
    CLK => clk,
    RST => rst,
    EN  => en_p,
    I   => plant_i,
    O   => plant_o
  );

  -- Modelling of multiple clock domains for the controller and the plant.
  -- For now, a single clock and different enable signals are used.
  -- In practice, the time domain of the plant and the controller are unrelated.
  -- Therefore, the plant should have its own time constant.
  -- The controller is likely to require a board specific instantiation of some PLL/DCM/MMCM.
  -- Hence, it makes sense to keep it outside of the UUT.
  b_clks: block
    signal cnt_c, cnt_p: unsigned(7 downto 0);
  begin

    clk <= not clk after c_clk/2;
    axi_aclk <= not axi_aclk after c_axi_aclk/2;

    p_clks: process(clk)
    begin
      if rising_edge(clk) then
        if RST then
          cnt_c <= (others=>'0');
          cnt_p <= (others=>'0');
        else
          cnt_c <= (others=>'0') when cnt_c?=9 else cnt_c+1;
          cnt_p <= (others=>'0') when cnt_c?=99 else cnt_p+1;
        end if;
      end if;
    end process;

    en_c <= cnt_c?=1;
    en_p <= cnt_p?=1;
  end block;

end arch;
