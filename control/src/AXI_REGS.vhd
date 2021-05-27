library ieee;
context ieee.ieee_std_context;

entity AXI_REGS is
  generic (
    G_REG_NUM          : natural := 4;
    G_AXI_S_ADDR_WIDTH : integer := 4;
    G_AXI_S_DATA_WIDTH : integer := 32
  );
  port (
    REGS          : out std_logic_vector(G_REG_NUM*G_AXI_S_DATA_WIDTH-1 downto 0);
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
    AXI_S_RREADY  : in  std_logic
  );
end entity;

architecture arch of AXI_REGS is

  signal axi_awaddr  : std_logic_vector(G_AXI_S_ADDR_WIDTH-1 downto 0);
  signal axi_awready : std_logic;
  signal axi_wready  : std_logic;
  signal axi_bresp   : std_logic_vector(1 downto 0);
  signal axi_bvalid  : std_logic;
  signal axi_araddr  : std_logic_vector(G_AXI_S_ADDR_WIDTH-1 downto 0);
  signal axi_arready : std_logic;
  signal axi_rdata   : std_logic_vector(G_AXI_S_DATA_WIDTH-1 downto 0);
  signal axi_rresp   : std_logic_vector(1 downto 0);
  signal axi_rvalid  : std_logic;

  type slv_reg_t is array (0 to G_REG_NUM-1) of std_logic_vector(G_AXI_S_DATA_WIDTH-1 downto 0);
  signal slv_reg : slv_reg_t;

  signal aw_en : std_logic;

begin

  AXI_S_AWREADY <= axi_awready;
  AXI_S_WREADY  <= axi_wready;
  AXI_S_BRESP   <= axi_bresp;
  AXI_S_BVALID  <= axi_bvalid;
  AXI_S_ARREADY <= axi_arready;
  AXI_S_RDATA   <= axi_rdata;
  AXI_S_RRESP   <= axi_rresp;
  AXI_S_RVALID  <= axi_rvalid;

  process (AXI_S_ACLK)

    -- Helper function for computing the number of bits required for a range
    function wordLength( depth: natural ) return natural is
      variable t,v: natural range 0 to depth := 0;
    begin
      t:=depth;
      while t>0 loop
        v:=v+1;
        t:=t/2;
      end loop;
      return v;
    end function;

    constant c_addrByteNum : natural := G_AXI_S_DATA_WIDTH/8;
    -- (c_addrLSB + c_addrBitNum downto c_addrLSB)
    constant c_addrLSB    : integer := wordLength(c_addrByteNum-1);
    constant c_addrBitNum : integer := wordLength(G_REG_NUM-1);

  begin

    if rising_edge(AXI_S_ACLK) then

      if not AXI_S_ARESETN then

        axi_awready <= '0';
        aw_en       <= '1';
        axi_awaddr  <= (others => '0');
        axi_wready  <= '0';
        axi_bvalid  <= '0';
        axi_bresp   <= "00"; --need to work more on the responses
        axi_arready <= '0';
        axi_araddr  <= (others => '1');
        axi_rvalid  <= '0';
        axi_rresp   <= "00";
        axi_rdata   <= (others => '0');

        for k in slv_reg'range loop
          slv_reg(k) <= (others => '0');
        end loop;

      else

        if (not axi_awready) and AXI_S_AWVALID and AXI_S_WVALID and aw_en then
          -- This design expects no outstanding transactions.
          axi_awready <= '1';
          aw_en <= '0';
        else
          axi_awready <= '0';
          if AXI_S_BREADY and axi_bvalid then
            aw_en <= '1';
          end if;
        end if;

        if (not axi_awready) and AXI_S_AWVALID and AXI_S_WVALID and aw_en then
          axi_awaddr <= AXI_S_AWADDR;
        end if;

        -- This design expects no outstanding transactions.
        axi_wready <= (not axi_wready) and AXI_S_WVALID and AXI_S_AWVALID and aw_en;

        if axi_awready and AXI_S_AWVALID and axi_wready and AXI_S_WVALID and (not axi_bvalid) then
          axi_bvalid <= '1';
          axi_bresp  <= "00";
        elsif AXI_S_BREADY and axi_bvalid then
          axi_bvalid <= '0'; -- there is a possibility that bready is always asserted high
        end if;

        if (not axi_arready) and AXI_S_ARVALID then
          axi_arready <= '1';
          axi_araddr  <= AXI_S_ARADDR;
        else
          axi_arready <= '0';
        end if;

        if axi_arready and AXI_S_ARVALID and (not axi_rvalid) then
          axi_rvalid <= '1';
          axi_rresp  <= "00";
        elsif axi_rvalid and AXI_S_RREADY then
          axi_rvalid <= '0';
        end if;

        if axi_wready and AXI_S_WVALID and axi_awready and AXI_S_AWVALID then
          for k in 0 to (c_addrByteNum-1) loop
            if ( AXI_S_WSTRB(k) = '1' ) then
              slv_reg(
                to_integer(unsigned(
                  axi_awaddr(c_addrLSB + c_addrBitNum downto c_addrLSB)
                ))
              )(k*8+7 downto k*8) <= AXI_S_WDATA(k*8+7 downto k*8);
            end if;
          end loop;
        end if;

        if axi_arready and AXI_S_ARVALID and (not axi_rvalid) then
          axi_rdata <= slv_reg(to_integer(unsigned(
            axi_araddr(c_addrLSB + c_addrBitNum downto c_addrLSB)
          )));
        end if;

      end if;
    end if;
  end process;

  -- Output all regs as a single std_logic_vector
  pack: for k in slv_reg'range generate
    REGS((k+1)*G_AXI_S_DATA_WIDTH-1 downto k*G_AXI_S_DATA_WIDTH) <= slv_reg(k);
  end generate;

end arch;
