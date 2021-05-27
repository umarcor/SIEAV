library ieee;
context ieee.ieee_std_context;

entity DesignTop is
  generic (
    G_AXI_S_ADDR_WIDTH : integer := 4;
    G_AXI_S_DATA_WIDTH : integer := 16
  );
  port (
    CONTROLLER_CLK : in  std_logic;
    CONTROLLER_EN  : in  std_logic;

    AXI_S_ACLK    : in  std_logic;
    AXI_S_ARESETN : in  std_logic;
    AXI_S_AWADDR  : in  std_logic_vector(G_AXI_S_ADDR_WIDTH-1 downto 0);
    AXI_S_AWPROT  : in  std_logic_vector(2 downto 0);
    AXI_S_AWVALID : in  std_logic;
    AXI_S_AWREADY : out std_logic;
    AXI_S_WDATA   : in  std_logic_vector(G_AXI_S_DATA_WIDTH-1 downto 0);
    AXI_S_WSTRB   : in  std_logic_vector((G_AXI_S_DATA_WIDTH/8)-1 downto 0);
    AXI_S_WVALID  : in  std_logic;
    AXI_S_WREADY  : out std_logic;
    AXI_S_BRESP   : out std_logic_vector(1 downto 0);
    AXI_S_BVALID  : out std_logic;
    AXI_S_BREADY  : in  std_logic;
    AXI_S_ARADDR  : in  std_logic_vector(G_AXI_S_ADDR_WIDTH-1 downto 0);
    AXI_S_ARPROT  : in  std_logic_vector(2 downto 0);
    AXI_S_ARVALID : in  std_logic;
    AXI_S_ARREADY : out std_logic;
    AXI_S_RDATA   : out std_logic_vector(G_AXI_S_DATA_WIDTH-1 downto 0);
    AXI_S_RRESP   : out std_logic_vector(1 downto 0);
    AXI_S_RVALID  : out std_logic;
    AXI_S_RREADY  : in  std_logic;

    PLANT_I : out std_logic_vector(7 downto 0);
    PLANT_O : in  std_logic_vector(7 downto 0)
  );
end entity;

architecture arch of DesignTop is

  constant c_reg_num : natural := 4;

  signal regs : std_logic_vector(c_reg_num*G_AXI_S_DATA_WIDTH-1 downto 0);

  type reg_t is array (0 to c_reg_num-1) of std_logic_vector(G_AXI_S_DATA_WIDTH-1 downto 0);
  signal reg : reg_t;

begin

  -- AXI-Lite slave with G_REG_NUM registers, which outputs them as a single std_logic_vector
  i_axi2regs: entity work.AXI_REGS
  generic map (
    G_REG_NUM          => c_reg_num,
    G_AXI_S_ADDR_WIDTH => G_AXI_S_ADDR_WIDTH,
    G_AXI_S_DATA_WIDTH => G_AXI_S_DATA_WIDTH
  )
  port map (
    REGS          => regs,
    AXI_S_ACLK    => AXI_S_ACLK,
    AXI_S_ARESETN => AXI_S_ARESETN,
    AXI_S_AWADDR  => AXI_S_AWADDR,
    AXI_S_AWPROT  => AXI_S_AWPROT,
    AXI_S_AWVALID => AXI_S_AWVALID,
    AXI_S_AWREADY => AXI_S_AWREADY,
    AXI_S_WDATA   => AXI_S_WDATA,
    AXI_S_WSTRB   => AXI_S_WSTRB,
    AXI_S_WVALID  => AXI_S_WVALID,
    AXI_S_WREADY  => AXI_S_WREADY,
    AXI_S_BRESP   => AXI_S_BRESP,
    AXI_S_BVALID  => AXI_S_BVALID,
    AXI_S_BREADY  => AXI_S_BREADY,
    AXI_S_ARADDR  => AXI_S_ARADDR,
    AXI_S_ARPROT  => AXI_S_ARPROT,
    AXI_S_ARVALID => AXI_S_ARVALID,
    AXI_S_ARREADY => AXI_S_ARREADY,
    AXI_S_RDATA   => AXI_S_RDATA,
    AXI_S_RRESP   => AXI_S_RRESP,
    AXI_S_RVALID  => AXI_S_RVALID,
    AXI_S_RREADY  => AXI_S_RREADY
  );

  -- Unpack the regs from the single std_logic_vector output of AXI_REGS
  unpack: for k in reg'range generate
    reg(k) <= regs((k+1)*G_AXI_S_DATA_WIDTH-1 downto k*G_AXI_S_DATA_WIDTH);
  end generate;

  -- The actual controller system
  b_sys: block
    signal y, u: std_logic_vector(7 downto 0);
  begin

    -- Optional logic related to the processing of the output from the plant
    i_hold: entity work.hold
    port map (
      CONTROLLER_CLK,
      not AXI_S_ARESETN,
      '1',
      PLANT_O,
      y
    );

    -- The (PID) controller
    i_controller: entity work.ControllerWithExtParams
    port map (
      CLK => CONTROLLER_CLK,
      RST => not AXI_S_ARESETN,
      EN  => CONTROLLER_EN,
      R   => reg(0)(7 downto 0),
      KP  => reg(1),
      KI  => reg(2),
      KD  => reg(3),
      I   => y,
      O   => u
    );

    -- Optional logic related to driving the actuator at the input of the plant
    i_actuator: entity work.actuator
    port map (
      CONTROLLER_CLK,
      not AXI_S_ARESETN,
      '1',
      u,
      PLANT_I
    );

  end block;

end arch;
