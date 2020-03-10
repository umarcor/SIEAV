library ieee;
context ieee.ieee_std_context;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.vc_context;

entity vc_axis_stage is
  generic (
    m_axis : axi_stream_master_t;
    s_axis : axi_stream_slave_t;
    data_width : natural := 32;
    fifo_depth : natural := 4
  );
  port (
    clk, rstn: in std_logic
  );
end entity;

architecture vc of vc_axis_stage is

  type axis_t is record
    rdy, valid, last : std_logic;
    strb : std_logic_vector((data_width/8)-1 downto 0);
    data : std_logic_vector(data_width-1 downto 0);
  end record;

  signal m, s: axis_t;

begin

  vunit_axism: entity vunit_lib.axi_stream_master
  generic map (
    master => m_axis)
  port map (
    aclk   => clk,
    tvalid => m.valid,
    tready => m.rdy,
    tdata  => m.data,
    tlast  => m.last);

  vunit_axiss: entity vunit_lib.axi_stream_slave
  generic map (
    slave => s_axis)
  port map (
    aclk   => clk,
    tvalid => s.valid,
    tready => s.rdy,
    tdata  => s.data,
    tlast  => s.last);

--

  m.strb <= (others=>'1');

  uut: entity work.axis_stage
  generic map (
    data_width => data_width,
    fifo_depth => fifo_depth
  )
  port map (
    s_axis_clk   => clk,
    s_axis_rstn  => rstn,
    s_axis_rdy   => m.rdy,
    s_axis_data  => m.data,
    s_axis_valid => m.valid,
    s_axis_strb  => m.strb,
    s_axis_last  => m.last,

    m_axis_clk   => clk,
    m_axis_rstn  => rstn,
    m_axis_valid => s.valid,
    m_axis_data  => s.data,
    m_axis_rdy   => s.rdy,
    m_axis_strb  => s.strb,
    m_axis_last  => s.last
  );

end architecture;
